
;*****
;       math
;*****

;   macro

; --------------------------------------------------------------- u16 add 1
u16_add_1   .macro
    clc
    lda \1
    adc #1
    sta \1
    lda \1+1
    adc #0
    sta \1+1
.endm
; --------------------------------------------------------------- u16_sub_1
u16_sub_1   .macro
    sec
    lda \1
    sbc #1
    sta \1
    lda \1 +1
    sbc #0
    sta \1 +1
.endm
; --------------------------------------------------------------- if_u16_gt_0
if_u16_gt_0   .macro
        lda \1
        bne \2
        lda \1+1
        bne \2
.endm

;

math    .proc

    ;--------------------------------------------------------------- 
    
    math_store_reg    .byte  0        ; temporary storage

    ;---------------------------------------------------------------   u8/s8 ?=

    s8_cmp_eq
    u8_cmp_eq

        lda  zpByte0
        cmp  zpByte1
        bne  +
        sec
        rts
    +
        clc
        rts

    ;--------------------------------------------------------------- u8/s8 > >=

    s8_cmp_ge   .proc
        lda  zpByte0
        cmp  zpByte1
        beq  s8_cmp_gt.s8_cmp_gt_ge
        jmp  s8_cmp_gt.s8_cmp_gt_gt
    .pend
    
    s8_cmp_gt   .proc

        lda  zpByte0
     s8_cmp_gt_gt       
        clc
        sbc  zpByte1
        bvc  +
        eor  #$80
    +               
        bpl  +
        bmi  s8_cmp_gt_else
    +
    s8_cmp_gt_ge
        sec
        rts
    s8_cmp_gt_else
        clc
        rts
        
    .pend        

    u8_cmp_ge   .proc
        lda  zpByte0
        cmp  zpByte1
        beq  u8_cmp_gt.u8_cmp_gt_ge
        jmp  u8_cmp_gt.u8_cmp_gt_gt
    .pend
    
    u8_cmp_gt   .proc
    
        lda  zpByte0
    u8_cmp_gt_gt
        cmp  zpByte1
        bcc  +
        beq  +
    u8_cmp_gt_ge
        sec
        rts
    +
        clc
        rts
        
    .pend
        
    ;---------------------------------------------------------------   u8/s8 < <=

    s8_cmp_le   .proc
        lda  zpByte0
        cmp  zpByte1
        beq  s8_cmp_lt.s8_cmp_lt_le
        jmp  s8_cmp_lt.s8_cmp_lt_lt
    .pend
    
    s8_cmp_lt   .proc

        lda  zpByte0
    s8_cmp_lt_lt
        sec
        sbc  zpByte1
        bvc  +
        eor  #$80
    +               
        bpl  +
    s8_cmp_lt_le
        sec
        rts
    +
        clc
        rts
    .pend

    u8_cmp_le   .proc
        lda  zpByte0
        cmp  zpByte1
        beq  u8_cmp_lt.u8_cmp_lt_le
        jmp  u8_cmp_lt.u8_cmp_lt_lt
    .pend
    
    u8_cmp_lt   .proc

        lda  zpByte0
    u8_cmp_lt_lt
        cmp  zpByte1
        bcs  +
    u8_cmp_lt_le
        sec
        rts
    +
        clc
        rts
    
    .pend
    
    ; --------------------------------------------------------------- u16/s16 ?=

    s16_cmp_eq
    u16_cmp_eq

        lda  zpWord0
        cmp  zpWord1
        bne  s16_cmp_eq_else
        ldy  zpWord0+1        
        cpy  zpWord1+1
        bne  s16_cmp_eq_else
        sec
        rts
    s16_cmp_eq_else
        clc
        rts

    ; --------------------------------------------------------------- u16/s16 <
    
    s16_cmp_le
    
        jsr s16_cmp_eq
        bcc s16_cmp_lt
        rts
         
    s16_cmp_lt

        ldy  zpWord0+1
        lda  zpWord0
        cmp  zpWord1
        tya
        sbc  zpWord1+1
        bvc  +
        eor  #$80
    +               
        bpl  s16_cmp_lt_else
        sec
        rts
    s16_cmp_lt_else
        clc
        rts

    
    ; --------------------------------------------------------------- u16/s16 >

    s16_cmp_ge
    
        jsr s16_cmp_eq
        bcc s16_cmp_gt
        rts
        
    s16_cmp_gt

        ldy  zpWord1+1
        lda  zpWord1
        cmp  zpWord0
        tya
        sbc  zpWord0+1
        bvc  +
        eor  #$80
        +               
        bpl  s16_cmp_gt_else
        sec
        rts
    s16_cmp_gt_else
        clc
        rts

    ; ---------------------------------------------------------------

    u16_cmp_le
    
        jsr u16_cmp_eq
        bcc u16_cmp_lt
        rts
        
    u16_cmp_lt

        ldy  zpWord0+1
        lda  zpWord0
        cpy  zpWord1+1
        bcc  +
        bne  u16_cmp_lt_else
        cmp  zpWord1
        bcs  u16_cmp_lt_else
    +
        sec
        rts
    u16_cmp_lt_else
        clc
        rts

    ; ---------------------------------------------------------------

    u16_cmp_ge
    
        jsr u16_cmp_eq
        bcc u16_cmp_gt
        rts
        
    u16_cmp_gt

        ldy  zpWord0+1
        lda  zpWord0
        cpy  zpWord1+1
        bcc  u16_cmp_gt_else
        bne  +
        cmp  zpWord1
        bcc  u16_cmp_gt_else
    +               
        beq  u16_cmp_gt_else
        sec
        rts
    u16_cmp_gt_else
        clc
        rts

    ; ---------------------------------------------------------------   mul_bytes
    ;
    ;   multiply 2 bytes A and Y, result as byte in A  
    ;   (signed or unsigned)
    ;
    ;   input   :   a,y
    ;   output  :   a

    mul_u8
    mul_s8
    mul_bytes    .proc
        
            sta  zpa            ; num1
            sty  zpy            ; num2
            lda  #0
            beq  _enterloop
    _doAdd        
            clc
            adc  zpa
    _loop        
            asl  zpa
    _enterloop    
            lsr  zpy
            bcs  _doAdd
            bne  _loop
            
            rts
    .pend

    ; --------------------------------------------------------------- mul_bytes_into_u16
    ;
    ;   multiply 2 bytes A and Y, result as word in A/Y (unsigned)
    ;
    ;   input   :   a,y
    ;   output  :   a:y
    ;
    
    mul_bytes_into_u16    .proc
            sta  zpa
            sty  zpy
            stx  zpx

            lda  #0
            ldx  #8
            lsr  zpa
    -        
            bcc  +
            clc
            adc  zpy
    +        
            ror  a
            ror  zpa
            dex
            bne  -
            tay
            lda  zpa
            ldx  zpx
            
            rts
    .pend
        
    ;..........................................................................
    ;
    ;   multiply two 16-bit words into a 32-bit zpDWord0  (signed and unsigned)
    ;
    ;      input    :
    ;   
    ;           A/Y             = first 16-bit number, 
    ;           zpWord0 in ZP   = second 16-bit number
    ;
    ;      output   :
    ;        
    ;           zpDWord0  4-bytes/32-bits product, LSB order (low-to-high)
    ;
    ;     result    :     zpDWord0  :=  zpWord0 * zpWord1
    ;

    multiply_words    .proc

            sta  zpWord1
            sty  zpWord1+1
            stx  zpx
    mult16        
            lda  #0
            sta  zpDWord0+2     ; clear upper bits of product
            sta  zpDWord0+3
            ldx  #16            ; for all 16 bits...
    -         
            lsr  zpWord0+1      ; divide multiplier by 2
            ror  zpWord0
            bcc  +
            lda  zpDWord0+2     ; get upper half of product and add multiplicand
            clc
            adc  zpWord1
            sta  zpDWord0+2
            lda  zpDWord0+3
            adc  zpWord1+1
    +         
            ror  a              ; rotate partial product
            sta  zpDWord0+3
            ror  zpDWord0+2
            ror  zpDWord0+1
            ror  zpDWord0
            dex
            bne  -
            ldx  zpx
            
            rts

    .pend

    ;........................................ div_s8
    ;
    ;   divide A by Y, result quotient in A, remainder in Y   (signed)
    ;
    ;   Inputs:
    ;       a       =   8-bit numerator
    ;       y       =   8-bit denominator
    ;   Outputs:
    ;       a       =   a / y       ( signed   )
    ;       y       =   remainder   ( unsigned ) 
    ;
    
    div_s8    .proc
         
            sta  zpa
            tya
            eor  zpa
            php             ; save sign
            lda  zpa
            bpl  +
            eor  #$ff
            sec
            adc  #0         ; make it positive
    +        
            pha
            tya
            bpl  +
            eor  #$ff
            sec
            adc  #0         ; make it positive
            tay
    +        
            pla
            jsr  internal_div_u8
            sta  zpByte0
            plp
            bpl  +
            tya
            eor  #$ff
            sec
            adc  #0         ; negate result
                            ;   a   result
            ldy zpByte0     ;   y   remainder
    +        
            rts

    .pend

    internal_div_u8    .proc

            sty  zpy
            sta  zpa
            stx  zpx

            lda  #0
            ldx  #8
            asl  zpa
    -        
            rol  a
            cmp  zpy
            bcc  +
            sbc  zpy
    +        
            rol  zpa
            dex
            bne  -
            ldy  zpa
            ldx  zpx
            
            rts
    .pend
    
    ;........................................ div_u8
    ;
    ;   divide A by Y, result quotient in A, remainder in Y   (unsigned)
    ;
    ;   Inputs:
    ;       a       =   8-bit numerator
    ;       y       =   8-bit denominator
    ;   Outputs:
    ;       a       =   a / y       ( unsigned   )
    ;       y       =   remainder   ( unsigned ) 
    ;

    div_u8    .proc
    
        sta zpByte0
        sty zpByte1
        
        lda #0
        ldx #8
        asl zpByte0
    L1  
        rol
        cmp zpByte1
        bcc L2
        sbc zpByte1
    L2 
        rol zpByte0
        dex
        bne L1
        tay
        lda zpByte0
        
        rts
    .pend
    
    ;

.pend



;;;
;;
;
