

; *********
;       stack
; *********

; ------------------------------------------------- sev

stack .proc

    ; ------------------------------------------------- stack address
    
    .weak
        lo = $ce00      ;   ce00    +   ff
        hi = $cf00      ;   cf00    +   ff
    .endweak
        
    ; ------------------------------------------------- stack pointer
    
    old     .byte   0       ;  old
    
    pointer .byte   $ff     ;   top

    ; ------------------------------------------------- push/pop byte
    ;
    ;   input   :   a   push
    ;   output  :   a   pop
    ;           :   c(0) overflow   c(1) push
        

    push_byte    .proc
            ldx stack.pointer
            cpx #0
            bne protect
            clc
            sev
            rts
    protect
            sta stack.lo,x
            pha
            lda #0
            sta stack.hi,x
            pla
            
            dex
            stx stack.pointer
            
            sec
            clv
            rts
    .pend

    pop_byte    .proc
            ldx stack.pointer
            cpx #255
            bne protect
            clc
            sev
            rts
    protect
            inx
            stx stack.pointer
            
            lda stack.lo,x

            sec
            clv
            rts
    .pend

    ; ------------------------------------------------- push/pop word   [v]
    ;
    ;   input   :   ay  ->   push
    ;   output  :   ay  <-   pop
    ;           :   c(0) overflow   c(1) push
    
    push_word    .proc
            ldx stack.pointer
            cpx #0
            bne protect
            clc
            sev
            rts
    protect
            sta stack.lo,x  ;   lo+0    a<
            tya
            sta stack.hi,x  ;   hi+1    y>
            
            dex             ;   x
            stx stack.pointer
            
            sec
            clv
            rts
    
    .pend

    pop_word    .proc
            ldx stack.pointer
            cpx #255
            bne protect
            clc
            sev
            rts
    protect
            inx
            stx stack.pointer
            
            ldy stack.hi,x  ;   hi+1    y>
            lda stack.lo,x  ;   lo+0    a<

            sec
            clv
            rts

    .pend
        
    ; ------------------------------------------------- write_byte_to_address_on_stack
    ;
    ;   input   :   a
    ;
    ; -- write the byte in A to the memory address on the top of the stack
        
    poke = write_byte_to_address_on_stack
        
    write_byte_to_address_on_stack    .proc

        ldx  stack.pointer

        ldy  stack.lo+1,x
        sty  zpWord1
        
        ldy  stack.hi+1,x
        sty  zpWord1+1
        
        ldy  #0
        sta  (zpWord1),y
        
        inx
        
        rts
        
    .pend

    ; ------------------------------------------------- read_byte_from_address_on_stack
    ;
    ;   output   :   a
    ;
    ; -- read the byte from the memory address on the top of the stack 

    peek = read_byte_from_address_on_stack
    
    read_byte_from_address_on_stack    .proc

        ldx  stack.pointer
        
        lda  stack.lo+1,x
        ldy  stack.hi+1,x
        
        sta  zpWord1
        sty  zpWord1+1
        ldy  #0
        lda  (zpWord1),y
        
        rts
        
    .pend

    ; ------------------------------------------------- push_sp , pop_sp
    ;
    ;   input    :   /
    ;   output   :   /
    ;   
    
    push_sp .proc
        lda stack.pointer
        jsr push_byte
        rts
    .pend
    
    pop_sp .proc
        jsr pop_byte
        sta stack.pointer
        rts
    .pend
        
    ; ------------------------------------------------- fast stack multiplication
        
    mul_byte_3    .proc
        ; X + X*2
        lda  stack.lo+1,x
        asl  a
        clc
        adc  stack.lo+1,x
        sta  stack.lo+1,x
        rts
    .pend

    mul_word_3    .proc
        ; W*2 + W
        lda  stack.hi+1,x
        sta  zpa
        lda  stack.lo+1,x
        asl  a
        rol  zpa
        clc
        adc  stack.lo+1,x
        sta  stack.lo+1,x
        lda  zpa
        adc  stack.hi+1,x
        sta  stack.hi+1,x
        rts
    .pend

    mul_byte_5    .proc
            ; X*4 + X
            lda  stack.lo+1,x
            asl  a
            asl  a
            clc
            adc  stack.lo+1,x
            sta  stack.lo+1,x
            rts
    .pend

    mul_word_5    .proc
            ; W*4 + W
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            clc
            adc  stack.lo+1,x
            sta  stack.lo+1,x
            lda  zpa
            adc  stack.hi+1,x
            sta  stack.hi+1,x
            rts
    .pend

    mul_byte_6    .proc
            ; (X*2 + X)*2
            lda  stack.lo+1,x
            asl  a
            clc
            adc  stack.lo+1,x
            asl  a
            sta  stack.lo+1,x
            rts
    .pend

    mul_word_6    .proc
            ; (W*2 + W)*2
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            asl  a
            rol  zpa
            clc
            adc  stack.lo+1,x
            sta  stack.lo+1,x
            lda  zpa
            adc  stack.hi+1,x
            asl  stack.lo+1,x
            rol  a
            sta  stack.hi+1,x
            rts
    .pend

    mul_byte_7    .proc
            ; X*8 - X
            lda  stack.lo+1,x
            asl  a
            asl  a
            asl  a
            sec
            sbc  stack.lo+1,x
            sta  stack.lo+1,x
            rts
    .pend

    mul_word_7    .proc
            ; W*8 - W
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            sec
            sbc  stack.lo+1,x
            sta  stack.lo+1,x
            lda  zpa
            sbc  stack.hi+1,x
            sta  stack.hi+1,x
            rts
    .pend

    mul_byte_9    .proc
            ; X*8 + X
            lda  stack.lo+1,x
            asl  a
            asl  a
            asl  a
            clc
            adc  stack.lo+1,x
            sta  stack.lo+1,x
            rts
    .pend

    mul_word_9    .proc
            ; W*8 + W
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            clc
            adc  stack.lo+1,x
            sta  stack.lo+1,x
            lda  zpa
            adc  stack.hi+1,x
            sta  stack.hi+1,x
            rts
    .pend

    mul_byte_10    .proc
            ; (X*4 + X)*2
            lda  stack.lo+1,x
            asl  a
            asl  a
            clc
            adc  stack.lo+1,x
            asl  a
            sta  stack.lo+1,x
            rts
    .pend

    mul_word_10    .proc
            ; (W*4 + W)*2
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            clc
            adc  stack.lo+1,x
            sta  stack.lo+1,x
            lda  zpa
            adc  stack.hi+1,x
            asl  stack.lo+1,x
            rol  a
            sta  stack.hi+1,x
            rts
    .pend

    mul_byte_11    .proc
            ; (X*2 + X)*4 - X
            lda  stack.lo+1,x
            asl  a
            clc
            adc  stack.lo+1,x
            asl  a
            asl  a
            sec
            sbc  stack.lo+1,x
            sta  stack.lo+1,x
            rts
    .pend

    mul_byte_12    .proc
            ; (X*2 + X)*4
            lda  stack.lo+1,x
            asl  a
            clc
            adc  stack.lo+1,x
            asl  a
            asl  a
            sta  stack.lo+1,x
            rts
    .pend

    mul_word_12    .proc
            ; (W*2 + W)*4
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            asl  a
            rol  zpa
            clc
            adc  stack.lo+1,x
            sta  stack.lo+1,x
            lda  zpa
            adc  stack.hi+1,x
            asl  stack.lo+1,x
            rol  a
            asl  stack.lo+1,x
            rol  a
            sta  stack.hi+1,x
            rts
    .pend

    mul_byte_13    .proc
            ; (X*2 + X)*4 + X
            lda  stack.lo+1,x
            asl  a
            clc
            adc  stack.lo+1,x
            asl  a
            asl  a
            clc
            adc  stack.lo+1,x
            sta  stack.lo+1,x
            rts
    .pend

    mul_byte_14    .proc
            ; (X*8 - X)*2
            lda  stack.lo+1,x
            asl  a
            asl  a
            asl  a
            sec
            sbc  stack.lo+1,x
            asl  a
            sta  stack.lo+1,x
            rts
    .pend

    ; mul_word_14 is skipped (too much code)

    mul_byte_15    .proc
            ; X*16 - X
            lda  stack.lo+1,x
            asl  a
            asl  a
            asl  a
            asl  a
            sec
            sbc  stack.lo+1,x
            sta  stack.lo+1,x
            rts
    .pend

    mul_word_15    .proc
            ; W*16 - W
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            sec
            sbc  stack.lo+1,x
            sta  stack.lo+1,x
            lda  zpa
            sbc  stack.hi+1,x
            sta  stack.hi+1,x
            rts
    .pend

    mul_byte_20    .proc
            ; (X*4 + X)*4
            lda  stack.lo+1,x
            asl  a
            asl  a
            clc
            adc  stack.lo+1,x
            asl  a
            asl  a
            sta  stack.lo+1,x
            rts
    .pend

    mul_word_20    .proc
            ; (W*4 + W)*4
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            clc
            adc  stack.lo+1,x
            sta  stack.lo+1,x
            lda  zpa
            adc  stack.hi+1,x
            asl  stack.lo+1,x
            rol  a
            asl  stack.lo+1,x
            rol  a
            sta  stack.hi+1,x
            rts
    .pend

    mul_byte_25    .proc
            ; (X*2 + X)*8 + X
            lda  stack.lo+1,x
            asl  a
            clc
            adc  stack.lo+1,x
            asl  a
            asl  a
            asl  a
            clc
            adc  stack.lo+1,x
            sta  stack.lo+1,x
            rts
    .pend

    mul_word_25    .proc
            ; W = (W*2 + W) *8 + W
            lda  stack.hi+1,x
            sta  zpWord0+1
            lda  stack.lo+1,x
            asl  a
            rol  zpWord0+1
            clc
            adc  stack.lo+1,x
            sta  zpWord0
            lda  zpWord0+1
            adc  stack.hi+1,x
            sta  zpWord0+1
            lda  zpWord0
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            asl  a
            rol  zpWord0+1
            clc
            adc  stack.lo+1,x
            sta  stack.lo+1,x
            lda  zpWord0+1
            adc  stack.hi+1,x
            sta  stack.hi+1,x
            rts
    .pend

    mul_byte_40    .proc
            lda  stack.lo+1,x
            and  #7
            tay
            lda  mul_byte_40._forties,y
            sta  stack.lo+1,x
            rts
    _forties    .byte  0*40, 1*40, 2*40, 3*40, 4*40, 5*40, 6*40, 7*40 & 255
    .pend

    mul_word_40    .proc
            ; (W*4 + W)*8
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            clc
            adc  stack.lo+1,x
            sta  stack.lo+1,x
            lda  zpa
            adc  stack.hi+1,x
            asl  stack.lo+1,x
            rol  a
            asl  stack.lo+1,x
            rol  a
            asl  stack.lo+1,x
            rol  a
            sta  stack.hi+1,x
            rts
    .pend

    mul_byte_50    .proc
            lda  stack.lo+1,x
            and  #7
            tay
            lda  mul_byte_50._fifties, y
            sta  stack.lo+1,x
            rts
    _fifties    .byte  0*50, 1*50, 2*50, 3*50, 4*50, 5*50, 6*50 & 255, 7*50 & 255
    .pend

    mul_word_50    .proc
            ; W = W * 25 * 2
            jsr  mul_word_25
            asl  stack.lo+1,x
            rol  stack.hi+1,x
            rts
    .pend

    mul_byte_80    .proc
            lda  stack.lo+1,x
            and  #3
            tay
            lda  mul_byte_80._eighties, y
            sta  stack.lo+1,x
            rts
    _eighties    .byte  0*80, 1*80, 2*80, 3*80
    .pend

    mul_word_80    .proc
            ; W = W * 40 * 2
            jsr  mul_word_40
            asl  stack.lo+1,x
            rol  stack.hi+1,x
            rts
    .pend

    mul_byte_100    .proc
            lda  stack.lo+1,x
            and  #3
            tay
            lda  mul_byte_100._hundreds, y
            sta  stack.lo+1,x
            rts
    _hundreds    .byte  0*100, 1*100, 2*100, 3*100 & 255
    .pend

    mul_word_100    .proc
            ; W = W * 25 * 4
            jsr  stack.mul_word_25
            asl  stack.lo+1,x
            rol  stack.hi+1,x
            asl  stack.lo+1,x
            rol  stack.hi+1,x
            rts
    .pend

    mul_word_320    .proc
            ; stackW = stackLo * 256 + stackLo * 64     (stackHi doesn't matter)
            ldy  stack.lo+1,x
            lda  #0
            sta  stack.hi+1,x
            tya
            asl  a
            rol  stack.hi+1,x
            asl  a
            rol  stack.hi+1,x
            asl  a
            rol  stack.hi+1,x
            asl  a
            rol  stack.hi+1,x
            asl  a
            rol  stack.hi+1,x
            asl  a
            rol  stack.hi+1,x
            sta  stack.lo+1,x
            tya
            clc
            adc  stack.hi+1,x
            sta  stack.hi+1,x
            rts
    .pend

    mul_word_640    .proc
            ; stackW = (stackLo * 2 * 320)    (stackHi doesn't matter)
            asl  stack.lo+1,x
            jmp  mul_word_320
    .pend
        
    ; ------------------------------------------------- fast stack shift

    shift_left_w_7    .proc
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            asl  a
            rol  zpa
    _shift6        
            asl  a
            rol  zpa
    _shift5        
            asl  a
            rol  zpa
    _shift4        
            asl  a
            rol  zpa
    _shift3        
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            asl  a
            rol  zpa

            sta  stack.lo+1,x
            lda  zpa
            sta  stack.hi+1,x
            rts
    .pend

    shift_left_w_6    .proc
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            jmp  shift_left_w_7._shift6
    .pend

    shift_left_w_5    .proc
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            jmp  shift_left_w_7._shift5
    .pend

    shift_left_w_4    .proc
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            jmp  shift_left_w_7._shift4
    .pend

    shift_left_w_3    .proc
            lda  stack.hi+1,x
            sta  zpa
            lda  stack.lo+1,x
            jmp  shift_left_w_7._shift3
    .pend

    shift_right_uw_7    .proc
            lda  stack.lo+1,x
            sta  zpa
            lda  stack.hi+1,x

            lsr  a
            ror  zpa
    _shift6        
            lsr  a
            ror  zpa
    _shift5        
            lsr  a
            ror  zpa
    _shift4        
            lsr  a
            ror  zpa
    _shift3        
            lsr  a
            ror  zpa
            lsr  a
            ror  zpa
            lsr  a
            ror  zpa

            sta  stack.hi+1,x
            lda  zpa
            sta  stack.lo+1,x
            rts
    .pend

    shift_right_uw_6    .proc
            lda  stack.lo+1,x
            sta  zpa
            lda  stack.hi+1,x
            jmp  shift_right_uw_7._shift6
    .pend

    shift_right_uw_5    .proc
            lda  stack.lo+1,x
            sta  zpa
            lda  stack.hi+1,x
            jmp  shift_right_uw_7._shift5
    .pend

    shift_right_uw_4    .proc
            lda  stack.lo+1,x
            sta  zpa
            lda  stack.hi+1,x
            jmp  shift_right_uw_7._shift4
    .pend

    shift_right_uw_3    .proc
            lda  stack.lo+1,x
            sta  zpa
            lda  stack.hi+1,x
            jmp  shift_right_uw_7._shift3
    .pend

    shift_right_w_7        .proc
            lda  stack.lo+1,x
            sta  zpWord0
            lda  stack.hi+1,x
            sta  zpWord0+1

            asl  a
            ror  zpWord0+1
            ror  zpWord0

            lda  zpWord0+1
    _shift6        
            asl  a
            ror  zpWord0+1
            ror  zpWord0
            lda  zpWord0+1
    _shift5        
            asl  a
            ror  zpWord0+1
            ror  zpWord0
            lda  zpWord0+1
    _shift4        
            asl  a
            ror  zpWord0+1
            ror  zpWord0
            lda  zpWord0+1
    _shift3        
            asl  a
            ror  zpWord0+1
            ror  zpWord0
            lda  zpWord0+1
            asl  a
            ror  zpWord0+1
            ror  zpWord0
            lda  zpWord0+1
            asl  a
            ror  zpWord0+1
            ror  zpWord0

            lda  zpWord0
            sta  stack.lo+1,x
            lda  zpWord0+1
            sta  stack.hi+1,x
            rts
    .pend

    shift_right_w_6    .proc
            lda  stack.lo+1,x
            sta  zpWord0
            lda  stack.hi+1,x
            sta  zpWord0+1
            jmp  shift_right_w_7._shift6
    .pend

    shift_right_w_5    .proc
            lda  stack.lo+1,x
            sta  zpWord0
            lda  stack.hi+1,x
            sta  zpWord0+1
            jmp  shift_right_w_7._shift5
    .pend

    shift_right_w_4    .proc
            lda  stack.lo+1,x
            sta  zpWord0
            lda  stack.hi+1,x
            sta  zpWord0+1
            jmp  shift_right_w_7._shift4
    .pend

    shift_right_w_3    .proc
            lda  stack.lo+1,x
            sta  zpWord0
            lda  stack.hi+1,x
            sta  zpWord0+1
            jmp  shift_right_w_7._shift3
    .pend

    shift_left_w_num_u8    .proc
            ; -- variable number of shifts left
            inx
            stx  stack.pointer
            
            ldy  stack.lo,x
            bne  _shift
            rts
    _shift        
            asl  stack.lo+1,x
            rol  stack.hi+1,x
            dey
            bne  _shift
            rts
    .pend

    shift_right_num_u16    .proc
            ; -- uword variable number of shifts right
            inx
            stx  stack.pointer
            
            ldy  stack.lo,x
            bne  _shift
            rts
    _shift        
            lsr  stack.hi+1,x
            ror  stack.lo+1,x
            dey
            bne  _shift
            rts
    .pend

    ; ------------------------------------------------------------- debug sp

    debug .proc
        lda #'['
        jsr sys.CHROUT
        
        sec
        lda stack.pointer
        jsr std.print_u8_hex
        
        lda #']'
        jsr sys.CHROUT
        
        rts
    .pend
    
    ; ------------------------------------------------------------- operator

    neg_b        .proc
        lda  #0
        sec
        sbc  stack.lo+1,x
        sta  stack.lo+1,x
        rts
    .pend

    neg_w        .proc
        sec
        lda  #0
        sbc  stack.lo+1,x
        sta  stack.lo+1,x
        lda  #0
        sbc  stack.hi+1,x
        sta  stack.hi+1,x
        rts
    .pend

    inv_w       .proc
        lda  stack.lo+1,x
        eor  #255
        sta  stack.lo+1,x
        lda  stack.hi+1,x
        eor  #255
        sta  stack.hi+1,x
        rts
    .pend

    bitand_b    .proc
        ; -- bitwise and (of 2 bytes)
        lda stack.lo+2,x
        and stack.lo+1,x
        inx
        stx stack.pointer
        sta stack.lo+1,x
        rts
    .pend

    bitor_b        .proc
        ; -- bitwise or (of 2 bytes)
        lda stack.lo+2,x
        ora stack.lo+1,x
        inx
        stx stack.pointer
        sta stack.lo+1,x
        rts
    .pend

    bitxor_b    .proc
        ; -- bitwise xor (of 2 bytes)
        lda stack.lo+2,x
        eor stack.lo+1,x
        inx
        stx stack.pointer
        sta stack.lo+1,x
        rts
    .pend

    bitand_w    .proc
        ; -- bitwise and (of 2 words)
        lda stack.lo+2,x
        and stack.lo+1,x
        sta stack.lo+2,x
        lda stack.hi+2,x
        and stack.hi+1,x
        sta stack.hi+2,x
        inx
        stx stack.pointer
        rts
    .pend

    bitor_w        .proc
        ; -- bitwise or (of 2 words)
        lda stack.lo+2,x
        ora stack.lo+1,x
        sta stack.lo+2,x
        lda stack.hi+2,x
        ora stack.hi+1,x
        sta stack.hi+2,x
        inx
        stx stack.pointer
        rts
    .pend

    bitxor_w    .proc
        ; -- bitwise xor (of 2 bytes)
        lda stack.lo+2,x
        eor stack.lo+1,x
        sta stack.lo+2,x
        lda stack.hi+2,x
        eor stack.hi+1,x
        sta stack.hi+2,x
        inx
        stx stack.pointer
        rts
    .pend

    mulw        .proc
        ; -- push word+word / uword+uword
        inx
        stx stack.pointer
        clc
        lda stack.lo,x
        adc stack.lo+1,x
        sta stack.lo+1,x
        lda stack.hi,x
        adc stack.hi+1,x
        sta stack.hi+1,x
        rts
    .pend

    sub_w        .proc
        inx
        stx stack.pointer
        sec
        lda stack.lo+1,x
        sbc stack.lo,x
        sta stack.lo+1,x
        lda stack.hi+1,x
        sbc stack.hi,x
        sta stack.hi+1,x
        rts
    .pend

    add_w        .proc
        inx
        stx stack.pointer
        clc
        lda  stack.lo,x
        adc  stack.lo+1,x
        sta  stack.lo+1,x
        lda  stack.hi,x
        adc  stack.hi+1,x
        sta  stack.hi+1,x
        rts
    .pend
                        
    mul_b    .proc
        ; -- b*b->b (signed and unsigned)
        inx
        stx stack.pointer
        lda stack.lo,x
        ldy stack.lo+1,x
        jsr math.multiply_bytes
        sta stack.lo+1,x
        rts
    .pend

    mul_w    .proc
        inx
        stx stack.pointer
        lda stack.lo,x
        sta zpWord0
        lda stack.hi,x
        sta zpWord0+1
        lda stack.lo+1,x
        ldy stack.hi+1,x
        jsr math.multiply_words
        lda math.multiply_words.result
        sta stack.lo+1,x
        lda math.multiply_words.result+1
        sta stack.hi+1,x
        rts
    .pend

    idiv_b        .proc
        jsr stack.pop_byte
        pha
        jsr stack.pop_byte
        pha

        pla
        tax
        pla
        tay
        txa

        jsr math.div_s8
        ;   a divisione 
        ;   y resto
        
        jsr stack.push_word
        
        rts
    .pend

    idiv_ub        .proc
        jsr stack.pop_byte
        pha
        jsr stack.pop_byte
        pha

        pla
        tax
        pla
        tay
        txa

        jsr math.div_u8
        ;   a divisione 
        ;   y resto
        
        jsr stack.push_word
        
        rts
    .pend

    idiv_uw        .proc 
        jsr stack.pop_word
        sta zpWord0
        sty zpWord0+1
        
        jsr stack.pop_word
        
        jsr math.div_u16

        jsr stack.push_word
        
        rts
    .pend

    idiv_w        .proc
        jsr stack.pop_word
        sta zpWord0
        sty zpWord0+1
        
        jsr stack.pop_word
        
        jsr math.div_s16

        jsr stack.push_word
        
        rts
    .pend

    ; ------------------------------------------------------------- compare
    
    equal_b        .proc
        ; -- are the two bytes on the stack identical?
        lda  stack.lo+2,x
        cmp  stack.lo+1,x
        bne  _equal_b_false
        
    _equal_b_true    
        lda  #1
        
    _equal_b_store
        inx
        stx stack.pointer

        sta  stack.lo+1,x
        rts
        
    _equal_b_false    
        lda  #0
        beq  _equal_b_store
        
    .pend

    equal_w        .proc
        ; -- are the two words on the stack identical?
        lda  stack.lo+1,x
        cmp  stack.lo+2,x
        bne  equal_b._equal_b_false
        lda  stack.hi+1,x
        cmp  stack.hi+2,x
        bne  equal_b._equal_b_false
        beq  equal_b._equal_b_true
    .pend

    notequal_b    .proc
        ; -- are the two bytes on the stack different?
        lda  stack.lo+1,x
        cmp  stack.lo+2,x
        beq  equal_b._equal_b_false
        bne  equal_b._equal_b_true
    .pend

    notequal_w    .proc
        ; -- are the two words on the stack different?
        lda  stack.hi+1,x
        cmp  stack.hi+2,x
        beq  notequal_b
        bne  equal_b._equal_b_true
    .pend

    less_ub        .proc
        lda  stack.lo+2,x
        cmp  stack.lo+1,x
        bcc  equal_b._equal_b_true
        bcs  equal_b._equal_b_false
    .pend

    less_b        .proc
        ; see http://www.6502.org/tutorials/compare_beyond.html
        lda  stack.lo+2,x
        sec
        sbc  stack.lo+1,x
        bvc  +
        eor  #$80
    +        
        bmi  equal_b._equal_b_true
        bpl  equal_b._equal_b_false
    .pend

    less_uw        .proc
        lda  stack.hi+2,x
        cmp  stack.hi+1,x
        bcc  equal_b._equal_b_true
        bne  equal_b._equal_b_false
        lda  stack.lo+2,x
        cmp  stack.lo+1,x
        bcc  equal_b._equal_b_true
        bcs  equal_b._equal_b_false
    .pend

    less_w        .proc
        lda  stack.lo+2,x
        cmp  stack.lo+1,x
        lda  stack.hi+2,x
        sbc  stack.hi+1,x
        bvc  +
        eor  #$80
    +        
        bmi  equal_b._equal_b_true
        bpl  equal_b._equal_b_false
    .pend

    lesseq_ub    .proc
        lda  stack.lo+1,x
        cmp  stack.lo+2,x
        bcs  equal_b._equal_b_true
        bcc  equal_b._equal_b_false
    .pend

    lesseq_b    .proc
        ; see http://www.6502.org/tutorials/compare_beyond.html
        lda  stack.lo+2,x
        clc
        sbc  stack.lo+1,x
        bvc  +
        eor  #$80
    +        
        bmi  equal_b._equal_b_true
        bpl  equal_b._equal_b_false
    .pend

    lesseq_uw    .proc
        lda  stack.hi+1,x
        cmp  stack.hi+2,x
        bcc  equal_b._equal_b_false
        bne  equal_b._equal_b_true
        lda  stack.lo+1,x
        cmp  stack.lo+2,x
        bcs  equal_b._equal_b_true
        bcc  equal_b._equal_b_false
    .pend

    lesseq_w    .proc
        lda  stack.lo+1,x
        cmp  stack.lo+2,x
        lda  stack.hi+1,x
        sbc  stack.hi+2,x
        bvc  +
        eor  #$80
    +        
        bpl  equal_b._equal_b_true
        bmi  equal_b._equal_b_false
    .pend

    greater_ub    .proc
        lda  stack.lo+2,x
        cmp  stack.lo+1,x
        beq  equal_b._equal_b_false
        bcs  equal_b._equal_b_true
        bcc  equal_b._equal_b_false
    .pend

    greater_b    .proc
        ; see http://www.6502.org/tutorials/compare_beyond.html
        lda  stack.lo+2,x
        clc
        sbc  stack.lo+1,x
        bvc  +
        eor  #$80
    +        
        bpl  equal_b._equal_b_true
        bmi  equal_b._equal_b_false
    .pend

    greater_uw    .proc
        lda  stack.hi+1,x
        cmp  stack.hi+2,x
        bcc  equal_b._equal_b_true
        bne  equal_b._equal_b_false
        lda  stack.lo+1,x
        cmp  stack.lo+2,x
        bcc  equal_b._equal_b_true
        bcs  equal_b._equal_b_false
    .pend

    greater_w    .proc
        lda  stack.lo+1,x
        cmp  stack.lo+2,x
        lda  stack.hi+1,x
        sbc  stack.hi+2,x
        bvc  +
        eor  #$80
    +        
        bmi  equal_b._equal_b_true
        bpl  equal_b._equal_b_false
    .pend

    greatereq_ub    .proc
        lda  stack.lo+2,x
        cmp  stack.lo+1,x
        bcs  equal_b._equal_b_true
        bcc  equal_b._equal_b_false
    .pend

    greatereq_b    .proc
        ; see http://www.6502.org/tutorials/compare_beyond.html
        lda  stack.lo+2,x
        sec
        sbc  stack.lo+1,x
        bvc  +
        eor  #$80
    +        
        bpl  equal_b._equal_b_true
        bmi  equal_b._equal_b_false
    .pend

    greatereq_uw    .proc
        lda  stack.hi+2,x
        cmp  stack.hi+1,x
        bcc  equal_b._equal_b_false
        bne  equal_b._equal_b_true
        lda  stack.lo+2,x
        cmp  stack.lo+1,x
        bcs  equal_b._equal_b_true
        bcc  equal_b._equal_b_false
    .pend

    greatereq_w    .proc
        lda  stack.lo+2,x
        cmp  stack.lo+1,x
        lda  stack.hi+2,x
        sbc  stack.hi+1,x
        bvc  +
        eor  #$80
    +        
        bmi  equal_b._equal_b_false
        bpl  equal_b._equal_b_true
    .pend

    ; ------------------------------------------------------------- compare 0
    
    equalzero_b    .proc
        lda  stack.lo+1,x
        beq  _true
        bne  _false
    _true        
        lda  #1
        sta  stack.lo+1,x
        rts
    _false        
        lda  #0
        sta  stack.lo+1,x
        rts
    .pend

    equalzero_w    .proc
        lda  stack.lo+1,x
        ora  stack.hi+1,x
        beq  equalzero_b._true
        bne  equalzero_b._false
    .pend

    notequalzero_b    .proc
        lda  stack.lo+1,x
        beq  equalzero_b._false
        bne  equalzero_b._true
    .pend

    notequalzero_w    .proc
        lda  stack.lo+1,x
        ora  stack.hi+1,x
        beq  equalzero_b._false
        bne  equalzero_b._true
    .pend

    lesszero_b    .proc
        lda  stack.lo+1,x
        bmi  equalzero_b._true
        jmp  equalzero_b._false
    .pend

    lesszero_w    .proc
        lda  stack.hi+1,x
        bmi  equalzero_b._true
        jmp  equalzero_b._false
    .pend

    greaterzero_ub    .proc
        lda  stack.lo+1,x
        bne  equalzero_b._true
        beq  equalzero_b._false
    .pend

    greaterzero_sb    .proc
        lda  stack.lo+1,x
        beq  equalzero_b._false
        bpl  equalzero_b._true
        bmi  equalzero_b._false
    .pend

    greaterzero_uw    .proc
        lda  stack.lo+1,x
        ora  stack.hi+1,x
        bne  equalzero_b._true
        beq  equalzero_b._false
    .pend

    greaterzero_sw    .proc
        lda  stack.hi+1,x
        bmi  equalzero_b._false
        ora  stack.lo+1,x
        beq  equalzero_b._false
        bne  equalzero_b._true
    .pend

    lessequalzero_sb    .proc
        lda  stack.lo+1,x
        bmi  equalzero_b._true
        beq  equalzero_b._true
        bne  equalzero_b._false
    .pend

    lessequalzero_sw    .proc
        lda  stack.hi+1,x
        bmi  equalzero_b._true
        ora  stack.lo+1,x
        beq  equalzero_b._true
        bne  equalzero_b._false
    .pend

    greaterequalzero_sb    .proc
        lda  stack.lo+1,x
        bpl  equalzero_b._true
        bmi  equalzero_b._false
    .pend

    greaterequalzero_sw    .proc
        lda  stack.hi+1,x
        bpl  equalzero_b._true
        bmi  equalzero_b._false
    .pend

    ; ................................................. signed extension
    ;
    ; -- sign extend the (signed) byte on the stack to full 16 bits
    ;    
    ;   input  : stack.lo+1 stack.hi+1
    ;   output : stack.lo+1 stack.hi+1

    byte_to_word    .proc
            lda  stack.lo+1,x
            ora  #$7f
            bmi  +
            lda  #0
    +        
            sta  stack.hi+1,x
            rts
    .pend

    ubyte_to_uword  .proc
            lda  #0
            sta  stack.hi+1,x
            rts
    .pend
    
    ;   .......................................................... abs b/w stack
    
    abs_b    .proc
        lda stack.lo+1,x
        
        jsr math.abs_b
        
        sta stack.lo+1,x
        tya
        sta stack.hi+1,x
        rts
    .pend

    abs_w   .proc
        lda stack.lo+1,x
        ldy stack.hi+1,x
        
        jsr math.abs_w
        
        sta stack.lo+1,x
        tya
        sta stack.hi+1,x
        rts
    .pend

    ;   .......................................................... sign b/w stack

    sign_b    .proc
        lda stack.lo+1,x
        
        jsr math.sign_b     ;   -1(-) 1(+)
        
        sta stack.lo+1,x
        lda #0
        sta stack.hi+1,x

        rts
    .pend

    sign_ub    .proc
        lda stack.lo+1,x
        
        jsr math.sign_ub     ;   0(=) 1(+)
        
        sta stack.lo+1,x
        lda #0
        sta stack.hi+1,x

        rts
    .pend

    sign_w    .proc
        lda stack.lo+1,x
        ldy stack.hi+1,x
        
        jsr math.sign_w     ;   -1(-) 1(+)
        
        sta stack.lo+1,x
        lda #0
        sta stack.hi+1,x

        rts
    .pend

    sign_uw    .proc
        lda stack.lo+1,x
        ldy stack.hi+1,x
        
        jsr math.sign_uw     ;   0(=) 1(+)
        
        sta stack.lo+1,x
        lda #0
        sta stack.hi+1,x
        
        rts
    .pend

    ;   .......................................................... sqrt

    sqrt    .proc
    
        lda stack.lo+1,x
        ldy stack.hi+1,x
        
        sta zpWord0
        tya
        sta zpWord0+1
        
        jsr math.sqrt

        sta stack.lo+1,x
        tya
        sta stack.hi+1,x

        rts
    .pend

    ;   ........................................................ remainder

    mod_ub    .proc
        jmp mod_uw
    .pend

    mod_uw    .proc
        
        lda  stack.lo+2,x
        sta  zpWord0
        lda  stack.hi+2,x
        sta  zpWord0+1
        
        lda  stack.lo+1,x
        pha
        lda  stack.hi+1,x
        tay
        pla
        
        inx
        inx
        stx stack.pointer
        
        jsr  math.div_u16

        lda zpWord1
        ldy zpWord1+1
        jsr stack.push_word
        
        rts
        
    .pend
    
.pend


;;;
;;
;


