
;*****
;       math
;*****

math    .proc


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
        
        
.pend



;;;
;;
;
