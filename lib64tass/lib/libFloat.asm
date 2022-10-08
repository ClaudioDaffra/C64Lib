
;**********
;   FLOAT
;**********

float .proc

    ;   constant
    
    AYINT_facmo         = $64
    PI                  = 3.141592653589793
    TWOPI               = 6.283185307179586

    ;   basic rom
    
    MOVFM       = $bba2
    FREADMEM    = $bba6
    CONUPK      = $ba8c
    FAREADMEM   = $ba90
    MOVFA       = $bbfc
    MOVAF       = $bc0c
    MOVEF       = $bc0f
    MOVMF       = $bbd4
    FTOSWORDYA  = $b1aa
    GETADR      = $b7f7
    QINT        = $bc9b
    AYINT       = $b1bf
    GIVAYF      = $b391
    FREADUY     = $b3a2
    FREADSA     = $bc3c
    FREADSTR    = $b7b5
    FPRINTLN    = $aabc
    FOUT        = $bddd
    FADDH       = $b849
    MUL10       = $bae2
    DIV10       = $bafe
    FCOMP       = $bc5b
    FADDT       = $b86a
    FADD        = $b867
    FSUBT       = $b853
    FSUB        = $b850
    FMULTT      = $ba2b
    FMULT       = $ba28
    FDIVT       = $bb12
    FDIV        = $bb0f
    FPWRT       = $bf7b
    FPWR        = $bf78
    FINLOG      = $bd7e
    NOTOP       = $aed4
    INT         = $bccc
    LOG         = $b9ea
    SGN         = $bc39
    SIGN        = $bc2b
    ABS         = $bc58
    SQR         = $bf71
    SQRA        = $bf74
    EXP         = $bfed
    NEGOP       = $bfb4
    RND         = $e097
    COS         = $e264
    SIN         = $e26b
    TAN         = $e2b4
    ATN         = $e30e
    
    ;   .................................................... print
    ;
    ;   input   :   ay  address (float)
    ;
    
    print   .proc

            stx  zpx

            jsr  float.MOVFM        ; load float into fac1
            jsr  float.FOUT         ; fac1 to string in A/Y
            sta  zpWord0
            sty  zpWord0+1
            ldy  #0
        -
            lda  (zpWord0),y
            beq  +
            
            jsr  c64.CHROUT
            
            iny
            bne  -
        +
            ldx  zpx
            
            rts
        
    .pend
    
    ;   .................................................... to_string
    ;
    ;   input
    ;           :   zpWord0 dest address
    ;           :   ay      address (float)
    ;   output
    ;           :   a       lenght string
    ;
    
    to_string   .proc

            stx  zpx

            jsr  float.MOVFM        ; load float into fac1
            jsr  float.FOUT         ; fac1 to string in A/Y
            sta  zpWord1
            sty  zpWord1+1
            ldy  #0
        -
            lda  (zpWord1),y
            beq  +

            sta  (zpWord0),y
            
            iny
            bne  -
        +

            lda  #0
            sta  (zpWord0),y
            
            tya
            
            ldx  zpx
            
            rts
        
    .pend
    
    ;   ......................................... load_from_string
    ;   
    ;   input   :   ay  address string
    ;   output  :   FAC1
    ;
    
    copy_from_string    .proc

        pha
        tya
        pha
        
        jsr basic.txtptr.push       ;   basic_txtptr_push
        
        pla
        tay
        pla

        jsr basic.txtptr.set

        jsr basic.get_char
        
        jsr basic.get_float_from_string

        jsr basic.txtptr.pop        ;   basic_txtptr_pop
        
        ; return fac1
        
        rts
        
    .pend
    
    ;   ......................................... copy_fac1_to_mem
    ;   
    ;   input   :   ay  address mem (original xy)
    ;   output  :   FAC1
    ;

    copy_fac1_to_mem    .proc

        tax

        jsr basic.copy_fac1_to_mem  ;    copy_fac1_to_mem

        rts
        
    .pend
    
    ;   ......................................... load
    ;
    ;   input       :   ay
    ;   output      :   fac1 | fac2
    
    copy_fac1_from_mem    .proc
        jsr basic.copy_mem_to_fac1
        rts
    .pend
    
    copy_fac2_from_mem    .proc
        jsr basic.copy_mem_to_fac2
        rts
    .pend
    
    ;   ......................................... round_fac1_to_mem
    ;   
    ;   input   :   ay  address mem (original xy)
    ;   output  :   FAC1
    ;

    round_fac1_to_mem    .proc

        tax
        jsr basic.round_fac1_to_mem 

        rts
        
    .pend

    ;   ......................................... copy_fac1_to_fac 1,2
    ;
    ;   input       :   fac1 | fac2
    ;   output      :   fac1 | fac2
    
    copy_fac1_to_fac2    .proc
        jsr basic.copy_fac1_to_fac2
        rts
    .pend
    
    copy_fac2_to_fac1    .proc
        jsr basic.copy_fac2_to_fac1
        rts
    .pend

    ;   ......................................... push/pop fac1,fac2
    ;
    ;   FAC1,FAC2 :
    ;
    
    ;   $61     holds the exponent
    ;   $62-$65 holds the mantissa
    ;   $66     holds the sign in bit 7
    ;
    
    push_fac1    .proc
        
        lda $61
        jsr stack.push_byte
        lda $62
        jsr stack.push_byte
        lda $63
        jsr stack.push_byte
        lda $64
        jsr stack.push_byte
        lda $65
        jsr stack.push_byte
        lda $66
        jsr stack.push_byte
        
        rts
    .pend

    pop_fac1    .proc
        
        jsr stack.pop_byte
        sta $66
        jsr stack.pop_byte
        sta $65
        jsr stack.pop_byte
        sta $64
        jsr stack.pop_byte
        sta $63
        jsr stack.pop_byte
        sta $62
        jsr stack.pop_byte
        sta $61
        
        rts
    .pend
    
    ;   FAC2:
    ;   
    ;   $69     holds the exponent
    ;   $6a-$6d holds the mantissa
    ;   $6e     holds the sign in bit 7

    push_fac2    .proc
        
        lda $69
        jsr stack.push_byte
        lda $6a
        jsr stack.push_byte
        lda $6b
        jsr stack.push_byte
        lda $6c
        jsr stack.push_byte
        lda $6d
        jsr stack.push_byte
        lda $6e
        jsr stack.push_byte
        
        rts
    .pend

    pop_fac2    .proc
        
        jsr stack.pop_byte
        sta $6e
        jsr stack.pop_byte
        sta $6d
        jsr stack.pop_byte
        sta $6c
        jsr stack.pop_byte
        sta $6b
        jsr stack.pop_byte
        sta $6a
        jsr stack.pop_byte
        sta $69
        
        rts
        
    .pend
    
.pend



;;;
;;
;



