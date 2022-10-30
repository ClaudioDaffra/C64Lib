
;***********
;   array
;***********


array   .proc

    ;........................................................................... sort_u8
    ; 
    ; sorting subroutine coded by mats rosengren (mats.rosengren@esa.int)
    ;
    ; input:    address of array to sort in zpWord0, 
    ;           length in A
    ;
    
    sort_u8    .proc

            sta  zpy
            lda  zpWord0
            bne  +
            dec  zpWord0+1
    +        
            dec  zpWord0
    _sortloop    
            ldy  zpy            ;start of subroutine sort
            lda  (zpWord0),y    ;last value in (what is left of) sequence to be sorted
            sta  zpx            ;save value. will be over-written by largest number
            jmp  _l2
    _l1        
            dey
            beq  _l3
            lda  (zpWord0),y
            cmp  zpWord1+1
            bcc  _l1
    _l2        
            sty  zpWord1        ;index of potentially largest value
            sta  zpWord1+1      ;potentially largest value
            jmp  _l1
    _l3        
            ldy  zpy            ;where the largest value shall be put
            lda  zpWord1+1      ;the largest value
            sta  (zpWord0),y    ;put largest value in place
            ldy  zpWord1        ;index of free space
            lda  zpx            ;the over-written value
            sta  (zpWord0),y    ;put the over-written value in the free space
            dec  zpy            ;end of the shorter sequence still left
            bne  _sortloop      ;start working with the shorter sequence
            rts
            
    .pend

    ;........................................................................... sort_s8
    ;
    ; sorting subroutine coded by mats rosengren (mats.rosengren@esa.int)
    ;
    ; input:    address of array to sort in zpWord0, 
    ;           length in A
    ; first, put pointer BEFORE array
    
    sort_s8	.proc
            sta  zpy
            lda  zpWord0
            bne  +
            dec  zpWord0+1
    +		dec  zpWord0
    _sortloop	
            ldy  zpy		        ;start of subroutine sort
            lda  (zpWord0),y	    ;last value in (what is left of) sequence to be sorted
            sta  zpa		        ;save value. will be over-written by largest number
            jmp  _l2
    _l1		dey
            beq  _l3
            lda  (zpWord0),y
            cmp  zpWord1+1
            bmi  _l1
    _l2		sty  zpWord1            ;index of potentially largest value
            sta  zpWord1+1          ;potentially largest value
            jmp  _l1
    _l3		ldy  zpy		        ;where the largest value shall be put
            lda  zpWord1+1          ;the largest value
            sta  (zpWord0),y	    ;put largest value in place
            ldy  zpWord1            ;index of free space
            lda  zpa		        ;the over-written value
            sta  (zpWord0),y	    ;put the over-written value in the free space
            dec  zpy		        ;end of the shorter sequence still left
            bne  _sortloop		    ;start working with the shorter sequence
            
            rts
    .pend

    ;........................................................................... sort_u16
    ; 
    ; sorting subroutine coded by mats rosengren (mats.rosengren@esa.int)
    ;
    ; input:    address of array to sort in zpWord0, 
    ;           length in A
    ;
    ; P.S.      first: subtract 2 of the pointer
    ;    
            
    sort_u16    .proc
            asl  a
            sta  zpy
            lda  zpWord0
            sec
            sbc  #2
            sta  zpWord0
            bcs  _sort_loop
            dec  zpWord0+1
    _sort_loop    
            ldy  zpy            ;start of subroutine sort
            lda  (zpWord0),y    ;last value in (what is left of) sequence to be sorted
            sta  _work3         ;save value. will be over-written by largest number
            iny
            lda  (zpWord0),y
            sta  _work3+1
            dey
            jmp  _l2
    _l1        
            dey
            dey
            beq  _l3
            iny
            lda  (zpWord0),y
            dey
            cmp  zpWord1+1
            bne  +
            lda  (zpWord0),y
            cmp  zpWord1
    +        
            bcc  _l1
    _l2        
            sty  _work1         ;index of potentially largest value
            lda  (zpWord0),y
            sta  zpWord1        ;potentially largest value
            iny
            lda  (zpWord0),y
            sta  zpWord1+1
            dey
            jmp  _l1
    _l3        
            ldy  zpy            ;where the largest value shall be put
            lda  zpWord1        ;the largest value
            sta  (zpWord0),y    ;put largest value in place
            iny
            lda  zpWord1+1
            sta  (zpWord0),y
            ldy  _work1         ;index of free space
            lda  _work3         ;the over-written value
            sta  (zpWord0),y    ;put the over-written value in the free space
            iny
            lda  _work3+1
            sta  (zpWord0),y
            dey
            dec  zpy            ;end of the shorter sequence still left
            dec  zpy
            bne  _sort_loop     ;start working with the shorter sequence
            
            rts
    _work1    .byte  0
    _work3    .word  0
    .pend

    ;........................................................................... sort_s16
    ; 
    ; sorting subroutine coded by mats rosengren (mats.rosengren@esa.int)
    ; input:  address of array to sort in zpWord0, length in A
    ; first: subtract 2 of the pointer
    
    sort_s16    .proc

            asl  a
            sta  zpy
            lda  zpWord0
            sec
            sbc  #2
            sta  zpWord0
            bcs  _sort_loop
            dec  zpWord0+1
    _sort_loop    
            ldy  zpy            ;start of subroutine sort
            lda  (zpWord0),y    ;last value in (what is left of) sequence to be sorted
            sta  _work3         ;save value. will be over-written by largest number
            iny
            lda  (zpWord0),y
            sta  _work3+1
            dey
            jmp  _l2
    _l1        
            dey
            dey
            beq  _l3
            lda  (zpWord0),y
            cmp  zpWord1
            iny
            lda  (zpWord0),y
            dey
            sbc  zpWord1+1
            bvc  +
            eor  #$80
    +        
            bmi  _l1
    _l2        
            sty  _work1             ;index of potentially largest value
            lda  (zpWord0),y
            sta  zpWord1            ;potentially largest value
            iny
            lda  (zpWord0),y
            sta  zpWord1+1
            dey
            jmp  _l1
    _l3        
            ldy  zpy                ;where the largest value shall be put
            lda  zpWord1            ;the largest value
            sta  (zpWord0),y        ;put largest value in place
            iny
            lda  zpWord1+1
            sta  (zpWord0),y
            ldy  _work1             ;index of free space
            lda  _work3             ;the over-written value
            sta  (zpWord0),y        ;put the over-written value in the free space
            iny
            lda  _work3+1
            sta  (zpWord0),y
            dey
            dec  zpy                ;end of the shorter sequence still left
            dec  zpy
            bne  _sort_loop         ;start working with the shorter sequence
            
            rts
    _work1    .byte  0
    _work3    .word  0
    
    .pend

    ;........................................................................... reverse_us8
    ;
    ; reverse an array of bytes (in-place)
    ;
    ; inputs:   pointer to array in zpWord0, 
    ;           length in A
    ;
    
    reverse_us8    .proc

    _index_right = zpWord1
    _index_left = zpWord1+1
    _loop_count = zpx
            sta  _loop_count
            lsr  _loop_count
            sec
            sbc  #1
            sta  _index_right
            lda  #0
            sta  _index_left
    _loop        
            ldy  _index_right
            lda  (zpWord0),y
            pha
            ldy  _index_left
            lda  (zpWord0),y
            ldy  _index_right
            sta  (zpWord0),y
            pla
            ldy  _index_left
            sta  (zpWord0),y
            inc  _index_left
            dec  _index_right
            dec  _loop_count
            bne  _loop
            rts
    .pend

    ;........................................................................... reverse_u16
    ;
    ; reverse an array of words (in-place)
    ;
    ; inputs:  pointer to array in zpWord0, 
    ;           length in A

    reverse_us16    .proc

    _index_first    = zpWord1
    _index_second   = zpWord1+1
    _loop_count     = zpx
    
            pha
            asl  a     ; *2 because words
            sec
            sbc  #2
            sta  _index_first
            lda  #0
            sta  _index_second
            pla
            lsr  a
            pha
            sta  _loop_count
            ; first reverse the lsbs
    _loop_lo    
            ldy  _index_first
            lda  (zpWord0),y
            pha
            ldy  _index_second
            lda  (zpWord0),y
            ldy  _index_first
            sta  (zpWord0),y
            pla
            ldy  _index_second
            sta  (zpWord0),y
            inc  _index_second
            inc  _index_second
            dec  _index_first
            dec  _index_first
            dec  _loop_count
            bne  _loop_lo
            ; now reverse the msbs
            dec  _index_second
            inc  _index_first
            inc  _index_first
            inc  _index_first
            pla
            sta  _loop_count
    _loop_hi    
            ldy  _index_first
            lda  (zpWord0),y
            pha
            ldy  _index_second
            lda  (zpWord0),y
            ldy  _index_first
            sta  (zpWord0),y
            pla
            ldy  _index_second
            sta  (zpWord0),y
            dec  _index_second
            dec  _index_second
            inc  _index_first
            inc  _index_first
            dec  _loop_count
            bne  _loop_hi

            rts
    .pend

    ;............................................................ rol/rol2 ror/ro2 ub
    ;
    ; -- rol  a ubyte in an array   ubyte
    ; -- ror  a ubyte in an array   ubyte
    ; -- rol2 a ubyte in an array   ubyte
    ; -- ror2 a ubyte in an array   ubyte
    ;
    ;   input   :
    ;               zpWord0     <-  address array
    ;               y           <-  index

    rol_ub    .proc
            lda  (zpWord0),y
            rol  a
            sta  (zpWord0),y
            rts
    .pend

    ror_ub    .proc
            lda  (zpWord0),y
            ror  a
            sta  (zpWord0),y
            rts
    .pend

    ror2_ub    .proc
            lda  (zpWord0),y
            lsr  a
            bcc  +
            ora  #$80
    +        
            sta  (zpWord0),y
            rts
    .pend

    rol2_ub    .proc
            lda  (zpWord0),y
            cmp  #$80
            rol  a
            sta  (zpWord0),y
            rts
    .pend

    ;............................................................ rol/rol2 ror/ro2 uw
    ;
    ; -- rol  a ubyte in an array   uword
    ; -- ror  a ubyte in an array   uword
    ; -- rol2 a ubyte in an array   uword
    ; -- ror2 a ubyte in an array   uword
    ;
    ;   input   :
    ;               zpWord0     <-  address array
    ;               y           <-  index
    
    ror_uw    .proc
            ; -- ror a uword in an array
            php
            tya
            asl  a
            tay
            iny
            lda  (zpWord0),y
            plp
            ror  a
            sta  (zpWord0),y
            dey
            lda  (zpWord0),y
            ror  a
            sta  (zpWord0),y
            rts
    .pend

    rol_uw    .proc
            php
            tya
            asl  a
            tay
            lda  (zpWord0),y
            plp
            rol  a
            sta  (zpWord0),y
            iny
            lda  (zpWord0),y
            rol  a
            sta  (zpWord0),y
            rts
    .pend

    rol2_uw    .proc
            tya
            asl  a
            tay
            lda  (zpWord0),y
            asl  a
            sta  (zpWord0),y
            iny
            lda  (zpWord0),y
            rol  a
            sta  (zpWord0),y
            bcc  +
            dey
            lda  (zpWord0),y
            adc  #0
            sta  (zpWord0),y
    +        
            rts
    .pend

    ror2_uw    .proc
            tya
            asl  a
            tay
            iny
            lda  (zpWord0),y
            lsr  a
            sta  (zpWord0),y
            dey
            lda  (zpWord0),y
            ror  a
            sta  (zpWord0),y
            bcc  +
            iny
            lda  (zpWord0),y
            ora  #$80
            sta  (zpWord0),y
    +        
            rts
    .pend

    ;   ....................................................... containment_byte
    ;
    ; -- check if a value exists in a byte array.
    ;    input  :   
    ;               zpWord0: address of the byte array
    ;               A = byte to check
    ;               Y = length of array (>=1).
    ;    output :   
    ;               boolean 0/1 in A.
    ;               (Carry) 1 , 0 
    ;
    
    containment_byte    .proc
            dey
    -        
            cmp  (zpWord0),y
            beq  +
            dey
            cpy  #255
            bne  -
            lda  #0
            clc
            rts
    +        
            lda  #1
            sec
            rts
    .pend

    ;   ....................................................... containment_byte
    ;
    ; -- check if a value exists in a byte array.
    ;    input  :   
    ;               zpWord0: address of the byte array
    ;               zpWord1: word to check
    ;               Y = length of array (>=1).
    ;    output :   
    ;               boolean 0/1 in A.
    ;              (Carry) 1 , 0 
    ;
    
    containment_word      .proc
        dey
        tya
        asl  a
        tay
    -        
        lda  zpWord1
        cmp  (zpWord0),y
        bne  +
        lda  zpWord1+1
        iny
        cmp  (zpWord0),y
        beq  _found
    +        
        dey
        dey
        cpy  #254
        bne  -
        lda  #0
        clc
        rts
    _found        
        lda  #1
        sec
        rts
    .pend

    ;  ............................................. calc index array
    ;
    ;  input   :   x y  mazy size
    ;  output  :   zpWord0
    ;

    short  .proc
        
        mul1    .proc
            jmp array_short_ret
        .pend
        mul2    .proc
            asl
            sta zpa
            jmp  array_short_ret
        .pend
        mul4    .proc
            asl
            asl
            sta zpa
            jmp array_short_ret
        .pend
        mul5    .proc
            sta zpa
            asl
            asl
            clc
            adc zpa
            sta zpa
            jmp  array_short_ret
        .pend
        
        ;   ..................................................... dim1
        dim1  .proc
                size1   .proc
                    txa     ;   mul by 1
                    jmp mul1
                .pend
                size2   .proc
                    txa     ;   mul by 2
                    jmp mul2
                .pend
                size4   .proc
                    txa     ;   mul by 4
                    jmp mul4
                .pend
                size5   .proc
                    txa ;   mul by 5
                    jmp mul5
                .pend
                sizex   .proc
                    txa ;   mul by size a*y -> a
                    ldy size
                    jsr math.mul_u8
                    jmp  array_short_ret
                .pend
        .pend
        ;   ..................................................... dim2
        dim2  .proc
                cndx2   .proc
                    sta dim2_maxy
                    stx dim2_x
                    sty dim2_y
                    
                    lda dim2_x
                    ldy dim2_maxy 

                    jsr math.mul_u8
                    clc
                    adc dim2_y
                    rts
                .pend
                size1   .proc
                    jsr cndx2
                    jmp array_short_ret
                .pend
                size2   .proc
                    jsr cndx2
                    jmp mul2
                .pend
                size4   .proc
                    jsr cndx2
                    jmp mul4
                .pend
                size5   .proc
                    jsr cndx2
                    jmp mul5
                .pend
                sizex   .proc
                    jsr cndx2   ; a
                    ldy size    ; y
                    jsr math.mul_u8 ; a*y
                    jmp array_short_ret
                .pend
                dim2_x      .byte 0
                dim2_y      .byte 0
                dim2_maxy   .byte 0
        .pend
                
        array_short_ret
            sta zpa
            jsr math.zpWord0_add_zpa
            rts
    
    size    .byte   0
    .pend

.pend


;;;
;;
;

