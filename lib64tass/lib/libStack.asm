

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
        ;
        
        push_byte    .proc
        
            ldx stack.pointer
            
            sta stack.lo,x
            
            dex
            stx stack.pointer
            
            rts
        
        .pend

        pop_byte    .proc
        
            ldx stack.pointer
            inx
            stx stack.pointer 
            
            lda stack.lo,x

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

