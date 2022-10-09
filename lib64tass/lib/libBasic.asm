

;*********
; basic
;*********


basic   .proc

    getchar_inc_ptr         =   $0073
    get_char                =   $0079   ;   output  ->  a
    TXTPTR                  =   $007A

    GETBYTE                 =   $b79E   ;   output  ->  x
    NEWSTATEMENT            =   $a7ae

    get_float_from_string   =   $BCF3   ;

    copy_fac1_to_mem        =   $BBD4   ;   input   -> xy
    
    copy_fac1_to_fac2       =   $BC0F   ;   input   -> fac2=fac1
    copy_fac1_to_fac2_round =   $BC0C   ;   input   -> fac2=fac1    
    copy_fac2_to_fac1       =   $BBFC   ;   input   -> fac1=fac2
    
    ;   $bba2 = Load FAC1 from the 5 bytes pointed to by A/Y (low)/(high). 
    ;   Returns Y = 0 and A loaded with the exponent, 
    ;   affecting the processor status flags.

    copy_mem_to_fac1        =   $bba2   ;   input   -> ay
    
    ;   $ba8c = Load FAC2 from the 5 bytes pointed to by A/Y (low)/(high). 
    ;   Returns with FAC1's exponent in A.
    
    copy_mem_to_fac2        =   $ba8c   ;   input   -> ay
    
    round_fac1_to_mem       =   $bbd4   ;   input   -> xy
    
    ;
    
    float   .proc

        ;   $b86a = Entry if FAC2 already loaded. 
        ;   The accumulator must load FAC1 exponent ($61) 
        ;   immediately before calling to properly set the zero flag.

        add =   $b86a   ;   fac1    :=  fac1    +   fac2

        ;   $b853 = Entry if FAC2 already loaded.

        sub =   $b853   ;   fac1    :=  fac1    -   fac2

        ;   $ba2b = Entry if FAC2 already loaded. 
        ;   Accumulator must load FAC1 exponent ($61) 
        ;   beforehand to set the zero flag.

        mul =   $ba2b   ;   fac1    :=  fac1    *   fac2

        ;  $bb12 = Entry if FAC2 already loaded. 
        ;  Accumulator must load FAC1 exponent ($61) 
        ;  beforehand to set the zero flag. 
        ;  Sign comparison is not performed and ARISGN byte at $6f is not set, 
        ;  which has to be accounted for when using this entry point. 
        ;  Hard to debug sign errors may occur otherwise.

        div =   $bb12   ;   fac1    :=  fac1    /   fac2    ,   remainer fac2

        ; $bae2 = Multiply FAC1 by 10
        ; 
        ; Quickly multiplies FAC1 by 10. 2 is added to the exponent (x4). 
        ; Then, the original value is added to the result (x5). 
        ; Finally, the exponent is incremented again (x10).

        mul_10  = $bae2

        ; $bafe = Divide FAC1 by 10
        ; 
        ; Not as quick as Multiply by 10. Shifts FAC1 to FAC2, 
        ; loads FAC1 with the constant 10 from ROM, 
        ; and falls through to the division routine. 
        ; Note: This routine treats FAC1 as positive even if it is not.

        div_10  = $bafe

        ; $bc5b = Compare FAC1 with memory contents at A/Y (lo/high)
        ; 
        ; Returns with A = 
        ;     $00 if the values are equal, 
        ;     $01 if FAC1 > MEM, or 
        ;     $ff if FAC1 < MEM. Uses the vector at $24 to address the variable, 
        ;     leaving FAC1 and FAC2 unchanged. 

        compare =   $bc5b 

        ;

        ;

    .pend
    
    ;

    txtptr  .proc

        push  .proc
            lda TXTPTR
            ldy TXTPTR+1
            jsr stack.push_word
            rts
        .pend
        
        pop  .proc
            jsr stack.pop_word
            sta TXTPTR
            sty TXTPTR+1
            rts
        .pend

        set  .proc
            sta $7A     ; set
            sty $7B
            rts
        .pend
        
    .pend
    
.pend


;;;
;;
;
