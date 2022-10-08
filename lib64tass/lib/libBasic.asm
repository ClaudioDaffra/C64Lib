

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
    
    copy_mem_to_fac1        =   $BBA2   ;   input   -> ay
    copy_mem_to_fac2        =   $BB8C   ;   input   -> ay
    
    round_fac1_to_mem       =   $bbd4   ;   input   -> xy
    
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
