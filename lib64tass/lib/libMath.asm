
;*****
;       math
;*****

;   macro

; --------------------------------------------------------------- logical true false

if_true  .macro ;   non settato     =   0
    bcs \1        
.endm

if_false .macro ;  settato         =   1
    bcc \1         
.endm

sev .macro
    sec
    lda #$80    ; set overflow
    sbc #$01
.endm
        
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

    mul_u8          =   mul_bytes
    mul_s8          =   mul_bytes
    multiply_bytes  =   mul_bytes
    
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

    result = zpDWord0
    
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
    ;       a       =   a / y       ( unsigned  )
    ;       y       =   remainder   ( unsigned  ) 
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
    
    ;.......................................................................    div_u16
    ;
    ;   divide two unsigned words (16 bit each) into 16 bit results
    ;
    ;    input:  
    ;            zpWord0    :   16 bit number, 
    ;            A/Y        :   16 bit divisor
    ;    output: 
    ;            zpWord1    :   16 bit remainder, 
    ;            A/Y        :   16 bit division result
    ;            zpWord0
    ;            flag V     :   1 = division by zero
    ;
    ;   signed word division: make everything positive and fix sign afterwards
        
    div_s16    .proc

            cmp     #$00
            bne     check_divByZero
            cpy     #$00
            bne     check_divByZero
            sev
            rts
            
     check_divByZero
     
            sta saveA
            sty saveY
            
            sta  zpWord1
            sty  zpWord1+1
            lda  zpWord0+1
            eor  zpWord1+1
            php            ; save sign
            lda  zpWord0+1
            bpl  +
            lda  #0
            sec
            sbc  zpWord0
            sta  zpWord0
            lda  #0
            sbc  zpWord0+1
            sta  zpWord0+1
    +        
            lda  zpWord1+1
            bpl  +
            lda  #0
            sec
            sbc  zpWord1
            sta  zpWord1
            lda  #0
            sbc  zpWord1+1
            sta  zpWord1+1
    +        
            tay
            lda  zpWord1
            jsr  div_u16
            ;
            pha
            lda zpWord1
            sta zpWord3
            lda zpWord1+1
            sta zpWord3+1
            pla
            ;
            plp            ; restore sign
            bpl  +
            sta  zpWord1
            sty  zpWord1+1
            lda  #0
            sec
            sbc  zpWord1
            pha
            lda  #0
            sbc  zpWord1+1
            tay
            pla
    +       
            pha
            lda zpWord3
            sta zpWord1
            lda zpWord3+1
            sta zpWord1+1
            pla

            pha
            lda saveA
            sta zpWord3
            lda saveY
            sta zpWord3+1
            pla
            
            sta zpWord0
            sty zpWord0+1
            
            clv
            rts
     
     saveA  .byte   0
     saveY  .byte   0
    .pend

    ;.......................................................................    div_u16
    ;
    ;   divide two unsigned words (16 bit each) into 16 bit results
    ;
    ;    input:  
    ;            zpWord0    :   16 bit number, 
    ;            A/Y        :   16 bit divisor
    ;    output: 
    ;            zpWord1    :   in ZP: 16 bit remainder, 
    ;            A/Y        :   16 bit division result
    ;            zpWord0
    ;            flag V     :   1 = division by zero
    ;
    
    div_u16    .proc

    dividend    = zpWord0
    remainder   = zpWord1
    result      = zpWord0   ;   dividend
    divisor     = zpWord3
    
            cmp     #$00
            bne     check_divByZero
            cpy     #$00
            bne     check_divByZero
            sev
            rts
            
     check_divByZero
     
            sta  divisor
            sty  divisor+1
            stx  zpx
            lda  #0             ;preset remainder to 0
            sta  remainder
            sta  remainder+1
            ldx  #16            ;repeat for each bit: ...
    -        
            asl  dividend       ;dividend lb & hb*2, msb -> Carry
            rol  dividend+1
            rol  remainder      ;remainder lb & hb * 2 + msb from carry
            rol  remainder+1
            lda  remainder
            sec
            sbc  divisor        ;substract divisor to see if it fits in
            tay                 ;lb result -> Y, for we may need it later
            lda  remainder+1
            sbc  divisor+1
            bcc  +              ;if carry=0 then divisor didn't fit in yet

            sta  remainder+1    ;else save substraction result as new remainder,
            sty  remainder
            inc  result         ;and INCrement result cause divisor fit in 1 times
    +        
            dex
            bne  -

            lda  result
            ldy  result+1
            ldx  zpx

            clv
            rts

    .pend

    ;............................................................   lsr_byte_A
    ;
    ; support for bit shifting that is too large to be unrolled:
    ; -- lsr signed byte in A times the value in Y (assume >0)        
    ;
    ;   shift a >> y
    ;
    
    shift_right = lsr_byte_A
    lsr_byte_A    .proc
            cmp  #0
            bmi  _negative
    -        
            lsr  a
            dey
            bne  -
            rts
    _negative    
            lsr  a
            ora  #$80
            dey
            bne  _negative
            rts
    .pend


    ;............................... 
    ;   optimized multiplications    
    ;............................... 

    mul_byte_3    .proc
            ; A = A + A*2
            sta  zpa
            asl  a
            clc
            adc  zpa
            rts
    .pend

    mul_word_3    .proc
            ; AY = AY*2 + AY
            sta  zpWord0
            sty  zpWord0+1
            sta  zpWord1
            sty  zpWord1+1
            asl  a
            rol  zpWord0+1
            clc
            adc  zpWord1
            sta  zpWord0
            lda  zpWord0+1
            adc  zpWord1+1
            tay
            lda  zpWord0
            rts
    .pend

    mul_byte_5    .proc
            ; A = A*4 + A
            sta  zpa
            asl  a
            asl  a
            clc
            adc  zpa
            rts
    .pend

    mul_word_5    .proc
            ; AY = AY*4 + AY
            sta  zpWord0
            sty  zpWord0+1
            sta  zpWord1
            sty  zpWord1+1
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            clc
            adc  zpWord1
            sta  zpWord0
            lda  zpWord0+1
            adc  zpWord1+1
            tay
            lda  zpWord0
            rts
    .pend

    mul_byte_6    .proc
            ; A = (A*2 + A)*2
            sta  zpa
            asl  a
            clc
            adc  zpa
            asl  a
            rts
    .pend

    mul_word_6    .proc
            ; AY = (AY*2 + AY)*2
            sta  zpWord0
            sty  zpWord0+1
            sta  zpWord1
            sty  zpWord1+1
            asl  a
            rol  zpWord0+1
            clc
            adc  zpWord1
            sta  zpWord0
            tay
            lda  zpWord0+1
            adc  zpWord1+1
            sta  zpWord0+1
            tya
            asl  a
            rol  zpWord0+1
            ldy  zpWord0+1
            rts
    .pend

    mul_byte_7    .proc
            ; A = A*8 - A
            sta  zpa
            asl  a
            asl  a
            asl  a
            sec
            sbc  zpa
            rts
    .pend

    mul_word_7    .proc
            ; AY = AY*8 - AY
            sta  zpWord0
            sty  zpWord0+1
            sta  zpWord1
            sty  zpWord1+1
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            sec
            sbc  zpWord1
            sta  zpWord0
            lda  zpWord0+1
            sbc  zpWord1+1
            tay
            lda  zpWord0
            rts
    .pend

    mul_byte_9    .proc
            ; A = A*8 + A
            sta  zpa
            asl  a
            asl  a
            asl  a
            clc
            adc  zpa
            rts
    .pend

    mul_word_9    .proc
            ; AY = AY*8 + AY
            sta  zpWord0
            sty  zpWord0+1
            sta  zpWord1
            sty  zpWord1+1
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            clc
            adc  zpWord1
            sta  zpWord0
            lda  zpWord0+1
            adc  zpWord1+1
            tay
            lda  zpWord0
            rts
            rts
    .pend

    mul_byte_10    .proc
            ; A=(A*4 + A)*2
            sta  zpa
            asl  a
            asl  a
            clc
            adc  zpa
            asl  a
            rts
    .pend

    mul_word_10    .proc
            ; AY=(AY*4 + AY)*2
            sta  zpWord0
            sty  zpWord0+1
            sta  zpWord1
            sty  zpWord1+1
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            clc
            adc  zpWord1
            sta  zpWord0
            lda  zpWord0+1
            adc  zpWord1+1
            sta  zpWord0+1
            lda  zpWord0
            asl  a
            rol  zpWord0+1
            ldy  zpWord0+1
            rts
    .pend

    mul_byte_11    .proc
            ; A=(A*2 + A)*4 - A
            sta  zpa
            asl  a
            clc
            adc  zpa
            asl  a
            asl  a
            sec
            sbc  zpa
            rts
    .pend

    ; mul_word_11 is skipped (too much code)

    mul_byte_12    .proc
            ; A=(A*2 + A)*4
            sta  zpa
            asl  a
            clc
            adc  zpa
            asl  a
            asl  a
            rts
    .pend

    mul_word_12    .proc
            ; AY=(AY*2 + AY)*4
            sta  zpWord0
            sty  zpWord0+1
            sta  zpWord1
            sty  zpWord1+1
            asl  a
            rol  zpWord0+1
            clc
            adc  zpWord1
            sta  zpWord0
            lda  zpWord0+1
            adc  zpWord1+1
            sta  zpWord0+1
            lda  zpWord0
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            ldy  zpWord0+1
            rts
    .pend

    mul_byte_13    .proc
            ; A=(A*2 + A)*4 + A
            sta  zpa
            asl  a
            clc
            adc  zpa
            asl  a
            asl  a
            clc
            adc  zpa
            rts
    .pend

    ; mul_word_13 is skipped (too much code)

    mul_byte_14    .proc
            ; A=(A*8 - A)*2
            sta  zpa
            asl  a
            asl  a
            asl  a
            sec
            sbc  zpa
            asl  a
            rts
    .pend

    ; mul_word_14 is skipped (too much code)

    mul_byte_15    .proc
            ; A=A*16 - A
            sta  zpa
            asl  a
            asl  a
            asl  a
            asl  a
            sec
            sbc  zpa
            rts
    .pend

    mul_word_15    .proc
            ; AY = AY * 16 - AY
            sta  zpWord0
            sty  zpWord0+1
            sta  zpWord1
            sty  zpWord1+1
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            sec
            sbc  zpWord1
            sta  zpWord0
            lda  zpWord0+1
            sbc  zpWord1+1
            tay
            lda  zpWord0
            rts
    .pend

    mul_byte_20    .proc
            ; A=(A*4 + A)*4
            sta  zpa
            asl  a
            asl  a
            clc
            adc  zpa
            asl  a
            asl  a
            rts
    .pend

    mul_word_20    .proc
            ; AY = AY * 10 * 2
            jsr  mul_word_10
            sty  zpa
            asl  a
            rol  zpa
            ldy  zpa
            rts
    .pend

    mul_byte_25    .proc
            ; A=(A*2 + A)*8 + A
            sta  zpa
            asl  a
            clc
            adc  zpa
            asl  a
            asl  a
            asl  a
            clc
            adc  zpa
            rts
    .pend

    mul_word_25    .proc
            ; AY = (AY*2 + AY) *8 + AY
            sta  zpWord0
            sty  zpWord0+1
            sta  zpWord1
            sty  zpWord1+1
            asl  a
            rol  zpWord0+1
            clc
            adc  zpWord1
            sta  zpWord0
            lda  zpWord0+1
            adc  zpWord1+1
            sta  zpWord0+1
            lda  zpWord0
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            clc
            adc  zpWord1
            sta  zpWord0
            lda  zpWord0+1
            adc  zpWord1+1
            tay
            lda  zpWord0
            rts
    .pend

    mul_byte_40    .proc
            and  #7
            tay
            lda  _forties,y
            rts
    _forties    .byte  0*40, 1*40, 2*40, 3*40, 4*40, 5*40, 6*40, 7*40 & 255
    .pend

    mul_word_40    .proc
            ; AY = (AY*4 + AY)*8
            sta  zpWord0
            sty  zpWord0+1
            sta  zpWord1
            sty  zpWord1+1
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            clc
            adc  zpWord1
            sta  zpWord0
            lda  zpWord0+1
            adc  zpWord1+1
            asl  zpWord0
            rol  a
            asl  zpWord0
            rol  a
            asl  zpWord0
            rol  a
            tay
            lda  zpWord0
            rts
    .pend

    mul_byte_50    .proc
            and  #7
            tay
            lda  _fifties, y
            rts
    _fifties    .byte  0*50, 1*50, 2*50, 3*50, 4*50, 5*50, 6*50 & 255, 7*50 & 255
    .pend

    mul_word_50    .proc
            ; AY = AY * 25 * 2
            jsr  mul_word_25
            sty  zpa
            asl  a
            rol  zpa
            ldy  zpa
            rts
            .pend

    mul_byte_80    .proc
            and  #3
            tay
            lda  _eighties, y
            rts
    _eighties    .byte  0*80, 1*80, 2*80, 3*80
    .pend

    mul_word_80    .proc
            ; AY = AY * 40 * 2
            jsr  mul_word_40
            sty  zpa
            asl  a
            rol  zpa
            ldy  zpa
            rts
    .pend

    mul_byte_100    .proc
            and  #3
            tay
            lda  _hundreds, y
            rts
    _hundreds    .byte  0*100, 1*100, 2*100, 3*100 & 255
    .pend

    mul_word_100    .proc
            ; AY = AY * 25 * 4
            jsr  mul_word_25
            sty  zpa
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            ldy  zpa
            rts
    .pend

    mul_word_320    .proc
            ; AY = A * 256 + A * 64     (msb in Y doesn't matter)
            sta  zpy
            ldy  #0
            sty  zpa
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            pha
            clc
            lda  zpy
            adc  zpa
            tay
            pla
            rts
    .pend

    mul_word_640    .proc
            ; AY = (A * 2 * 320) (msb in Y doesn't matter)
            asl  a
            jmp  mul_word_320
    .pend

 
 
    ;...........................................................square
    ;
    ; -- calculate square root of signed word in AY, result in AY
    ; routine by Lee Davsion, source: http://6502.org/source/integers/square.htm
    ; using this routine is about twice as fast as doing a regular multiplication.
    ;
    ; Calculates the 16 bit unsigned integer square of the signed 16 bit integer in
    ; Numberl/Numberh.  The result is always in the range 0 to 65025 and is held in
    ; Squarel/Squareh
    ;
    ; The maximum input range is only +/-255 and no checking is done to ensure that
    ; this is so.
    ;
    ; This routine is useful if you are trying to draw circles as for any circle
    ;
    ; x^2+y^2=r^2 where x and y are the co-ordinates of any point on the circle and
    ; r is the circle radius
    ;
    ;   input   :   ay
    ;   output  :   ay
    ;
    
    square  .proc

    numberl = zpWord0       ; number to square low byte
    numberh = zpWord0+1     ; number to square high byte
    squarel = zpWord1       ; square low byte
    squareh = zpWord1+1     ; square high byte
    tempsq  = zpy           ; temp byte for intermediate result

        sta  numberl        ; zpWord0
        sty  numberh
        stx  zpx

        lda     #$00        ; clear a
        sta     squarel     ; clear square low byte
                            ; (no need to clear the high byte, it gets shifted out)
                            ; zpWord1
        lda    numberl      ; get number low byte   
        ldx    numberh      ; get number high  byte
        bpl    _nonneg      ; if +ve don't negate it
                            ; else do a two's complement
        eor    #$ff         ; invert
        sec                 ; +1
        adc    #$00         ; and add it
    _nonneg
        sta    tempsq       ; save abs(number)
        ldx    #$08         ; set bit count
    _nextr2bit
        asl    squarel      ; low byte *2
        rol    squareh      ; high byte *2+carry from low
        asl    a            ; shift number byte
        bcc    _nosqadd     ; don't do add if c = 0
        tay                 ; save a
        clc                 ; clear carry for add
        lda    tempsq       ; get number
        adc    squarel      ; add number^2 low byte
        sta    squarel      ; save number^2 low byte
        lda    #$00         ; clear a
        adc    squareh      ; add number^2 high byte
        sta    squareh      ; save number^2 high byte
        tya                 ; get a back
    _nosqadd
        dex                 ; decrement bit count
        bne    _nextr2bit   ; go do next bit

        lda  squarel
        ldy  squareh
        ldx  zpx
        rts

    .pend

    ; ......................................................... AY < zpWord0
    ;
    ;   input   :   ay , zpWord1
    ;   output  :   a   0 >=
    ;           :       1 <
    ;
    
    reg_cmp_s16_lt    .proc
        ; -- AY < zpWord1?
        cmp  zpWord1
        tya
        sbc  zpWord1+1
        bvc  +
        eor  #$80
    +        
        bmi  _true
        lda  #0
        rts
    _true        
        lda  #1
        rts
    .pend

    reg_cmp_lesseq_u16    .proc
            ; AY <= zpWord1?
            cpy  zpWord1+1
            beq  +
            bcc  _true
            lda  #0
            rts
    +        
            cmp  zpWord1
            bcc  _true
            beq  _true
            lda  #0
            rts
    _true        
            lda  #1
            rts
    .pend

    reg_cmp_lesseq_s16    .proc
            ; -- zpWord1 <= AY ?   (note: order different from other routines)
            cmp  zpWord1
            tya
            sbc  zpWord1+1
            bvc  +
            eor  #$80
    +        
            bpl  +
            lda  #0
            rts
    +        
            lda  #1
            rts
    .pend

    ;............................................... abs_b abs_w
    ;
    ; -- AY = abs(A)  (abs always returns unsigned word)
    ;
    ;   input   :   signed   a      ,   signed   ay
    ;   output  :   unsigned ay     ,   unsigned ay 
    ;

    abs_b    .proc    ; a
            ldy  #0
            cmp  #0
            bmi  +
            rts
    +        
            eor  #$ff
            clc
            adc  #1
            rts
    .pend

    abs_w    .proc  ;   ay
            cpy  #0
            bmi  +
            rts
    +        
            eor  #$ff
            pha
            tya
            eor  #$ff
            tay
            pla
            clc
            adc  #1
            bcc  +
            iny
    +        
            rts
    .pend

    ;   ........................................................ sign
    ;
    ;   sign_b  sign_ub
    ;   sign_w  sign_uw
    ;
    ;   input   :   a   ay
    ;   output  :   1 + ,   -1  -   ,   0   =
    ;
    
    sign_b    .proc
            cmp  #0
            beq  _zero
            bmi  _neg
            lda  #1
    _zero        
            rts
    _neg        
            lda  #-1    ; 255
            rts
    .pend

    sign_ub    .proc
            cmp  #0
            bne  _pos
            rts
    _pos        
            lda  #1
            rts
    .pend

    sign_uw    .proc
            cpy  #0
            beq  _possibly_zero
    _pos        
            lda  #1
            rts
    _possibly_zero    
            cmp  #0
            bne  _pos
            rts
    .pend

    sign_w   .proc
            cpy  #0
            beq  _possibly_zero
            bmi  _neg
    _pos        
            lda  #1
            rts
    _neg        
            lda  #-1
            rts
    _possibly_zero    
            cmp  #0
            bne  _pos
            rts
    .pend
    
    ;   ..................................................................... sqrt
    ;
    ; integer square root from  http://6502org.wikidot.com/software-math-sqrt
    ;
    ;   input   :   ay  
    ;   output  :   a
    
    sqrt    .proc

            txa
            pha
            lda  #0
            sta  zpa
            sta  zpy
            ldx  #8
    -        
            sec
            lda  zpWord0+1
            sbc  #$40
            tay
            lda  zpy
            sbc  zpa
            bcc  +
            sty  zpWord0+1
            sta  zpy
    +        
            rol  zpa
            asl  zpWord0
            rol  zpWord0+1
            rol  zpy
            asl  zpWord0
            rol  zpWord0+1
            rol  zpy
            dex
            bne  -
            pla
            tax
            lda  zpa
            rts
    .pend

    ;   ........................................................ add_uw sub_uw

.pend   



;;;
;;
;
