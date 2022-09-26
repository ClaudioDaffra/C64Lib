

; *********
;       stack
; *********

stack .proc

        .weak
            lo = $ce00      ;   ce00    +   ff
            hi = $cf00      ;   cf00    +   ff
        .endweak

        old     .byte   0       ;  old
        
        pointer .byte   $ff    ;   top

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
                rts
        protect
                sta stack.lo,x
                dex
                
                stx stack.pointer
                sec
                rts
        
        .pend

        pop_byte    .proc
        
                ldx stack.pointer
                cpx #255
                bne protect
                clc
                rts
        protect
                inx
                lda stack.lo,x
                
                stx stack.pointer
                sec
                rts

        .pend

        ; ------------------------------------------------- push/pop word
        ;
        ;   input   :   ay  ->   push
        ;   output  :   ay  <-   pop
        ;           :   c(0) overflow   c(1) push
        
        push_word    .proc
        
                ldx stack.pointer
                cpx #2
                bge protect
                clc
                rts
        protect
                sta stack.lo,x  ;   lo+0    a<
                dex
                
                tya
                sta stack.lo,x  ;   hi+1    y>
                dex

                stx stack.pointer
                sec
                rts
        
        .pend

        pop_word    .proc
        
                ldx stack.pointer
                cpx #253
                blt protect
                beq protect
                clc
                rts
        protect
                inx
                lda stack.lo,x  ;   hi+1    y>
                tay
                
                inx
                lda stack.lo,x  ;   lo+0    a<

                stx stack.pointer 
                sec
                rts

        .pend
        
        ; ------------------------------------------------- write_byte_to_address_on_stack
        ;
        ;   input   :   a
        ;
        ; -- write the byte in A to the memory address on the top of the stack
            
        write_byte_to_address_on_stack    .proc
 
            ldx  stack.pointer
            
            ldy  stack.lo+1,x
            sty  zpWord1
            ldy  stack.hi+1,x
            sty  zpWord1+1
            ldy  #0
            sta  (zpWord1),y
            
            rts
            
        .pend

        ; ------------------------------------------------- read_byte_from_address_on_stack
        ;
        ;   output   :   a
        ;
        ; -- read the byte from the memory address on the top of the stack 
            
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


        ;
.pend


;;;
;;
;


