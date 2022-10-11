
;**********
;   FLOAT
;**********

float .proc

    ;   predefined
    
    FL_ONE_const    .byte  129                      ; 1.0
    FL_ZERO_const   .byte  0,0,0,0,0                ; 0.0
    FL_LOG2_const   .byte  $80, $31, $72, $17, $f8  ; log(2)
    
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
    MUL10       = $bae2 ;
    DIV10       = $bafe ;
    FCOMP       = $bc5b ;
    FADDT       = $b86a ;
    FADD        = $b867 ;
    FSUBT       = $b853 ;
    FSUB        = $b850 ;
    FMULTT      = $ba2b ;
    FMULT       = $ba28 ;
    FDIVT       = $bb12 ;
    FDIV        = $bb0f ;
    FPWRT       = $bf7b ;
    FPWR        = $bf78
    FINLOG      = $bd7e
    NOTOP       = $aed4
    INT         = $bccc ;
    LOG         = $b9ea ;
    SGN         = $bc39 ;
    SIGN        = $bc2b ;
    ABS         = $bc58 ;
    SQR         = $bf71 ;
    SQRA        = $bf74 ;
    EXP         = $bfed ;
    NEGOP       = $bfb4 ;
    RND         = $e097 ;
    COS         = $e264 ;
    SIN         = $e26b ;
    TAN         = $e2b4 ;
    ATN         = $e30e ;
    
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

    print_fac1   .proc
            lda #<zpWord2
            ldy #>zpWord2
            jsr copy_fac1_to_mem
            lda #<zpWord2
            ldy #>zpWord2
            jsr print
            rts
    .pend

    
    ;   .................................................... to_string
    ;
    ;   input
    ;           :   zpWord0 dest address
    ;           :   ay      address (float)
    ;   output
    ;           :   a       length string
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
    copy_mem_to_fac1    .proc
        jsr basic.copy_mem_to_fac1
        rts
    .pend
    
    copy_mem_to_fac2    .proc
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

    ;   ......................................... push/pop mem
    ;
    ;   input   :   ay  address 
    ;   output  : 
    ;               -> from mem to stack 
    ;               -> from stack to mem

    push_mem    .proc
        sta zpWord0
        sty zpWord0+1

        ldy #0
    loop
        tya
        pha

        lda (zpWord0),y         ;   0,1,2,3,4
        jsr stack.push_byte

        pla
        tay

        iny
        cpy #5
        bne loop

        rts

    .pend
 
    pop_mem    .proc
        sta zpWord0
        sty zpWord0+1

        ldy #4
    loop
        tya
        pha
        
        jsr stack.pop_byte
        sta (zpWord0),y         ;   4,3,2,1,0

        pla
        tay
        
        dey
        cpy #$ff
        bne loop

        rts

    .pend
 
    ;   .......................................................... conv
    ;
    ;   convert ubyte in A          to float at address A/Y   
    ;   convert  byte in A          to float at address A/Y   
    ;   convert uword in zpWord0    to float at address A/Y
    ;   convert sword in zpWord0    to float at address A/Y
    ;
    ;   output  :   fac1
    ;
    
    conv_u8_to_fac1    .proc
        sta zpa
        
        stx zpx
        sta zpWord0
        sty zpWord0+1
        
        ldy zpa
        lda #0
        jsr GIVAYF ; to fac1

        ldx zpx
        rts
    .pend
        
    conv_s8_to_fac1     .proc
        sta zpa
        
        stx zpx
        sta zpWord0
        sty zpWord0+1
        
        lda zpa
        
        jsr FREADSA

        ldx zpx
        rts
    .pend

    GIVUAYFAY   .proc
     
        sty  $62
        sta  $63
        ldx  #$90
        sec
        jmp  $bc49      ; internal BASIC routine
        
    .pend
    
    conv_u16_to_fac1    .proc
        stx zpx
        
        jsr  GIVUAYFAY
        
        ldx zpx
        rts
    .pend

    conv_s16_to_fac1    .proc
        stx zpx

        sta zpa
        sty zpy
        lda zpy
        ldy zpa
        jsr GIVAYF
        
        ldx zpx
        rts
    .pend
    
    ;   .......................................................... cast
    ;
    ;   input   :   fac1
    ;
    ;   output  :   
    ;               (a)     u8 s8 
    ;               (ay)    u16 s16
    ;
    
    cast_fac1_to_u16    .proc

        stx  zpx
        jsr  GETADR     ; into Y/A
        ldx  zpx
        sta zpa
        sty zpy
        lda zpy
        ldy zpa
        
        rts
    .pend

    cast_fac1_to_u8    .proc

        jsr cast_fac1_to_u16
        ldy #0
        
        rts
    .pend
    
    cast_fac1_to_s16    .proc

        stx  zpx
        jsr  AYINT
        ldy  float.AYINT_facmo
        lda  float.AYINT_facmo+1
        ldx  zpx
        rts
    .pend

    cast_fac1_to_s8    .proc

        jsr cast_fac1_to_s16
        ldy #0
        rts
    .pend

    ;   .......................................................... operation
    ;
    
    add     .proc
        lda $61
        jsr basic.float.add
        rts
    .pend

    sub     .proc
        jsr  basic.float.sub
        rts
    .pend
    
    mul     .proc
        lda $61
        jsr basic.float.mul
        rts
    .pend

    swap     .proc
        jsr float.push_fac1
        jsr float.push_fac2
        jsr float.pop_fac1
        jsr float.pop_fac2
        rts
    .pend

    div     .proc               ;   fac1/fac2
        jsr swap
    fac2_fac1                   ;   fac2/fac1
        lda $61
        jsr basic.float.div
        rts
    .pend
    
    inc_1   .proc
        lda <#FL_ONE_const
        ldy >#FL_ONE_const
        jsr basic.copy_mem_to_fac2
        jsr float.add
        rts
    .pend

    dec_1   .proc
        lda <#FL_ONE_const
        ldy >#FL_ONE_const
        jsr basic.copy_mem_to_fac2
        jsr float.sub
        rts
    .pend

    mul_10     .proc
        jsr basic.float.mul_10
        rts
    .pend

    div_10     .proc       
        jsr basic.float.div_10
        rts
    .pend

    compare     .proc       
        jsr basic.float.compare
        rts
    .pend

    ;   ------------------------------------ boolean
    
    ;     $00 if FAC1 = 
    ;     $01 if FAC1 >
    ;     $ff if FAC1 <

    compare_ne     .proc       
        jsr basic.float.compare
        cmp #$00
        bne true
        clc
        rts
    true
        sec
        rts
    .pend
    
    compare_eq     .proc       
        jsr basic.float.compare
        cmp #$00
        bne false
        sec
        rts
    false
        clc
        rts
    .pend
    
    compare_lt     .proc       
        jsr basic.float.compare
        cmp #$ff
        bne false
        sec
        rts
    false
        clc
        rts
    .pend

    compare_le     .proc       
        jsr basic.float.compare
        cmp #$ff
        bne false
        cmp #$00
        bne false
        sec
        rts
    false
        clc
        rts
    .pend
    
    compare_gt     .proc       
        jsr basic.float.compare
        cmp #$01
        bne false
        sec
        rts
    false
        clc
        rts
    .pend
    
    compare_ge     .proc       
        jsr basic.float.compare
        cmp #$01
        bne false
        cmp #$00
        bne false
        sec
        rts
    false
        clc
        rts
    .pend

    ;   ------------------------------------ sign abs int
    
    sign     .proc       
        jsr basic.float.sign
        rts
    .pend

    abs     .proc       
        jsr basic.float.abs
        rts
    .pend

    int     .proc       
        jsr basic.float.int
        rts
    .pend

    ;   ------------------------------------ cos sin tan atan

    sin     .proc       
        jsr basic.float.sin
        rts
    .pend
    
    cos     .proc       
        jsr basic.float.cos
        rts
    .pend
    
    tan     .proc       
        jsr basic.float.tan
        rts
    .pend
    
    atan     .proc       
        jsr basic.float.atan
        rts
    .pend

    log     .proc       
        jsr basic.float.log
        rts
    .pend

    exp     .proc
        jsr basic.float.exp
        rts
    .pend

    pow     .proc               ;   :=  (FAC1^FAC2)
        jsr swap
    fac2_fac1                   ;   :=  (FAC2^FAC1)
        jsr basic.float.pow     
        rts
    .pend 
    
    sqr    .proc       
        jsr basic.float.sqr
        rts
    .pend 
    
    sqr_fac1    .proc       
        jsr basic.float.sqr_fac1
        rts
    .pend 
    
    sqr_fac2    .proc       
        jsr basic.float.sqr_fac2
        rts
    .pend 

    rnd    .proc       
        jsr basic.float.rnd
        rts
    .pend 
    
    ;

    ay  .proc
    
        add .proc
            jsr $b867                  ;   fac2 + fac1
            rts
        .pend

        sub .proc
            jsr $b850                  ;   fac2 - fac1
            rts
        .pend

        mul .proc
            jsr $ba28                  ;   fac2 * fac1 
            rts
        .pend

        div .proc
            jsr $bb0f                  ;   fac1 / fac2
            rts
        .pend
        
    .pend

    ;   ................................... calc index
    ;
    ;   input   :
    ;               ay  array   address
    ;                x  length
    ;
    ;   output  :
    ;
    ;               zpWord  address+(x*sizeof(float))
    ;               fac1
    
    calc_index  .proc
    
            sta zpa
            sty zpy
            sta zpWord0
            sty zpWord0+1
            stx zpx
    
            txa             ;   mul by 5
            asl
            asl
            clc
            adc zpx
            sta zpa         ;   index*size(5)
            
            clc             ;   zpWord0+index
            lda zpWord0
            adc zpa
            sta zpWord0
            clc
            lda zpWord0+1
            adc #0
            sta zpWord0+1
            
            lda zpWord0
            ldy zpWord0+1
            
            jsr float.copy_fac1_from_mem

            rts
    .pend
    
    ;   ................................... print_array
    ;
    ;   input   :
    ;               ay  array   address
    ;                x  max length
    ;
    ;   output  :
    ;               print array
    
    print_array .proc
    
        dex             ;   (0-9)   10 elements
        
        sta address
        sty address+1
        stx mod_max+1
        ldx #$ff
        stx index
    loop
        lda #char.space
        jsr c64.CHROUT
        
        inx 
        stx index
        
        lda address
        ldy address+1
        jsr float.calc_index
        
        lda #<tempFac
        ldy #>tempFac
        jsr float.copy_fac1_to_mem

        lda #<tempFac
        ldy #>tempFac
        jsr float.print
        
        ldx index
    mod_max
        cpx #$00        ;   modified
        
        bne loop

        rts
        
        tempFac .byte   0,0,0,0,0
        address .word   0
        index   .byte   0
        ;max     .byte   0
    
    .pend

    ;   ................................... array_reverse
    ;
    ;   input   :
    ;               zpWord      array   address
    ;               a           num elements
    ;
    ;   output  :
    ;               array reverrse
    
    a_mul_5   .proc
        sta  zpa
        asl  a
        asl  a
        clc
        adc  zpa
        rts
    .pend
    
    array_reverse   .proc
        
        _left_index     = zpWord1
        _right_index    = zpWord1+1
        _loop_count     = zpx

        pha
        jsr  a_mul_5
        sec
        sbc  #5
        sta  _right_index
        lda  #0
        sta  _left_index
        pla
        lsr  a
        sta  _loop_count
        _loop               ; push the left indexed float on the stack
        ldy  _left_index
        lda  (zpWord0),y
        pha
        iny
        lda  (zpWord0),y
        pha
        iny
        lda  (zpWord0),y
        pha
        iny
        lda  (zpWord0),y
        pha
        iny
        lda  (zpWord0),y
        pha
        ; copy right index float to left index float
        ldy  _right_index
        lda  (zpWord0),y
        ldy  _left_index
        sta  (zpWord0),y
        inc  _left_index
        inc  _right_index
        ldy  _right_index
        lda  (zpWord0),y
        ldy  _left_index
        sta  (zpWord0),y
        inc  _left_index
        inc  _right_index
        ldy  _right_index
        lda  (zpWord0),y
        ldy  _left_index
        sta  (zpWord0),y
        inc  _left_index
        inc  _right_index
        ldy  _right_index
        lda  (zpWord0),y
        ldy  _left_index
        sta  (zpWord0),y
        inc  _left_index
        inc  _right_index
        ldy  _right_index
        lda  (zpWord0),y
        ldy  _left_index
        sta  (zpWord0),y
        ; pop the float off the stack into the right index float
        ldy  _right_index
        pla
        sta  (zpWord0),y
        dey
        pla
        sta  (zpWord0),y
        dey
        pla
        sta  (zpWord0),y
        dey
        pla
        sta  (zpWord0),y
        dey
        pla
        sta  (zpWord0),y
        inc  _left_index
        lda  _right_index
        sec
        sbc  #9
        sta  _right_index
        dec  _loop_count
        bne  _loop
        rts

    .pend

    ;   ......................................................... rad a

    radA    .proc

        lda  #<angle
        ldy  #>angle
        jsr  MOVFM
        stx  zpx
        lda  #<_pi_div_180
        ldy  #>_pi_div_180
        jsr  FMULT
        ldx  zpx
        
        rts
        _pi_div_180 .byte 123, 14, 250, 53, 18  ; pi / 180
        angle       .byte  0,0,0,0,0            ; float
    .pend

    ;   ......................................................... sin a
    
    sinA    .proc

        lda  #<angle
        ldy  #>angle
        jsr  MOVFM
        stx  zpx
        jsr  SIN
        ldx  zpx
        
        rts
        angle   .byte  0,0,0,0,0  ; float
    .pend
    
    ;   ............................................................ copy
    ;
    ;   input   :   
    ;               zpWord0     (dest)
    ;               zpWord1     (source)
    ;
    ;               zpWord1[y]   :=  zpWord0[y]
    ;
    
    copy    .proc

        ldy  #0
        lda  (zpWord1),y
        sta  (zpWord0),y
        iny
        lda  (zpWord1),y
        sta  (zpWord0),y
        iny
        lda  (zpWord1),y
        sta  (zpWord0),y
        iny
        lda  (zpWord1),y
        sta  (zpWord0),y
        iny
        lda  (zpWord1),y
        sta  (zpWord0),y
        
        rts
        
    .pend
    
    ;   ............................................................ set_array
    ;
    ; -- set a float in an array to a value
    ;
    ;   input   :
    ;               zpWord0     ->  array address
    ;               zpWord1     ->  value    
    ;               x           ->  index

    set_array   .proc

        txa
        jsr float.a_mul_5
        sta zpa
        
        clc
        lda zpWord0
        adc zpa
        sta zpWord0
        lda zpWord0+1
        adc #$00
        sta zpWord0+1
        
        jsr float.copy
        
        rts
        
    .pend

    ;   ............................................................ set_array
    ;
    ; -- set a float in an array to a 0
    ;
    ;   input   :
    ;               zpWord0     ->  array
    ;               x           ->  index
    ;       
    ;               zpWord[x]   :=  0
    ;
    
    set0_array  .proc

        txa
        sta  zpa
        asl  a
        asl  a
        clc
        adc  zpa
        tay
        lda  #0
        sta  (zpWord0),y
        iny
        sta  (zpWord0),y
        iny
        sta  (zpWord0),y
        iny
        sta  (zpWord0),y
        iny
        sta  (zpWord0),y
        rts
        
    .pend

    ;   ............................................................ set_array_from_fac1
    ;
    ;   set a float in an array from a fac
    ;
    ;   input   :
    ;               zpWord0     ->  array
    ;               x           ->  index
    ;       
    ;               zpWord[x]   :=  fac
    ;

    set_array_from_fac1 .proc

        txa
        sta  zpa
        asl  a
        asl  a
        clc
        adc  zpa
        ldy  zpWord0+1
        clc
        adc  zpWord0
        bcc  +
        iny
    +
        stx  zpx
        tax
        jsr  float.MOVMF
        ldx  zpx
        
        rts
        
    .pend
    
.pend
 
;;;
;;
;



