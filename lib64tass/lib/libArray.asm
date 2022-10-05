
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


.pend


;;;
;;
;
