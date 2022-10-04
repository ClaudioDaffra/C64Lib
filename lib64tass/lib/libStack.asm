

; *********
;       stack
; *********

; ------------------------------------------------- sev

sev .macro
    sec
    lda #$80    ; set overflow
    sbc #$01
.endm
        
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

        poke    .proc
                jmp stack.write_byte_to_address_on_stack
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

        peek    .proc
                jmp read_byte_from_address_on_stack
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
        
        ;
        
.pend


;;;
;;
;


