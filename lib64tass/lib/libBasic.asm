

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

        ;     $bc2b = Evaulate sign of FAC1 (returned in A) $bc39 = Evaulate sign of FAC1 (returned in FAC1)
        ;     
        ;     These routines return 
        ;     $01 for positive numbers, 
        ;     $ff for negative numbers,
        ;     $00 for zeros. If you know a number is non-zero, 
        ;     it is quicker just to use BIT $66, or LDA $66, etc.

        sign = $bc2b

        ;   ABS   $bc58 = Returns absolute value of FAC1
        ;     
        ;   Simply LSR's the sign byte of FAC1 ($66) to put a zero in the MSB. 
        ;   This is easily done without the need for a JSR.

        abs = $bc58

        ;   INT   $bccc = Round FAC1 to Integer
        ;     
        ;   Takes FAC1 and rounds away the decimal to make it an integer. 
        ;   It is still, however, expressed as a FP number.

        int = $bccc

        ;   Trigonometry
        ;
        ;   $e26b = Sine(FAC1)
        ;   $e264 = Cosine(FAC1)
        ;   $e2b4 = Tangent(FAC1)
        ;   $e30e = Arc-Tangent(FAC1)
        ;   
        ;   All the trig routines, even though they only require FAC1 for input, trash FAC2. 
        ;   Enter all but ATAN with FAC1 expressed in radians. 
        ;   The sine routine uses the series evaluation routine to converge on a value. 
        ;   For cosine, the routine adds pi/2 (90 degrees) to FAC1, 
        ;   then falls through to the sine routine, because cos(x) = sin(x+(pi/2)). 
        ;   The tangent routine uses the fact that tan(x) = sin(x)/cos(x). 
        ;   ATAN uses its own series evaluation.

        sin     =   $e26b ; = Sine(FAC1)
        cos     =   $e264 ; = Cosine(FAC1)
        tan     =   $e2b4 ; = Tangent(FAC1)
        atan    =   $e30e ; = Arc-Tangent(FAC1)


        ;   5.1 Natural Log $b9ea = Returns the natural log of FAC1

        log =  $b9ea 
    
        ;   This returns the natural log of FAC1 in FAC1. 
        ;   The FAC1 can not be negative or zero, or else BASIC 
        ;   will respond with an ?ILLEGAL QUANTITY error. 
        ;   Calculated using a series.

        ;   5.2 EXP / e^x $bfed = Returns e raised to the power of FAC1.

        exp =  $bfed 
    
        ;   The opposite of log, i.e. log(exp(5)) = exp(log(5)) = 5, 
        ;   though the routine lacks the accuracy for this to always be true. 
        ;   Calculated using a series.
        ;   
        ;   5.3 Exponentiation / y^x
        ;   $bf7b = FAC2 raised to the power of FAC1 (FAC2^FAC1)

        pow =  $bf7b 
       
        ;   This routine uses the formula exp(x*log(y)) to calculate yx, 
        ;   so it calculates two series (log and exp). 
        ;   *** It is slow and not entirely accurate. 
        ;   For whole number powers, it is often quicker 
        ;   and more accurate to use a series of multiplies.

        ;   5.4 Square Root
        ;   $bf71 = Square root of FAC1
        ;   $bf74 = Square root of FAC2

        sqr      =  $bf71
        sqr_fac1 =  $bf71 
        sqr_fac2 =  $bf74 
        
        ;   The first address copies FAC1 into FAC2, before loading .5 
        ;   into FAC1 and falling through to the exponentiation routine. 
        ;   The second address skips the move and uses the value in FAC2. 
        ;   A quicker square root routine is described below.

        ;
        
    .pend
    
    ;   .......................................................... txtptr

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
    
    ;
    
.pend


;;;
;;
;
