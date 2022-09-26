

.cpu  '6502'
.enc  'none'

; ---- basic program with sys call ----

; [start address]

* = $0801
    ;           [line]
    .word  (+), 2022
    ;      [sys]                                     [rem]     [desc]
    .null  $9e, format(' %d ', program_entry_point), $3a, $8f, ' prg'
+   .word  0

;--------------------------------------------------------------- program_entry_point

program_entry_point

    jmp program

;--------------------------------------------------------------- lib

.include "../../lib/libC64.asm"
.include "../../lib/libMath.asm"
.include "../../lib/libSTDIO.asm"
.include "../../lib/libConv.asm"
.include "../../lib/libString.asm"


;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

main	.proc

    debug_stack .proc
    
            lda #'['
            jsr sys.CHROUT
            
            sec
            lda stack.pointer
            jsr std.print_u8_hex
            
            lda #']'
            jsr sys.CHROUT
            
            rts
    .pend

    print_pop_uword .proc
    
            lda #char.nl
            jsr sys.CHROUT
            
            jsr stack.pop_word
            
            jsr txt.print_u16_hex
            
            rts
    .pend
    
    start	.proc

            ;   program
 
            ;--------------------------------------------------------------- clear
 
            lda #' '
            ldy #color.green
            jsr txt.fill_screen

            ;--------------------------------------------------------------- 

            jsr debug_stack

            ;--------------------------------------------------------------- 
            
            jmp c4
            
            ;--------------------------------------------------------------- 
            
c1
            ; sp=255    ov
            ldx #255
            stx stack.pointer
            jsr stack.pop_byte
            if_false stack_overflow

c2
            ; sp=0    ov 
            ldx #0
            stx stack.pointer
            
            lda #'a'
            jsr stack.push_byte
            if_false stack_overflow

c3
            ; sp=255    sp=254    ov
            ldx #254
            stx stack.pointer
            jsr stack.pop_word
            if_false stack_overflow

c4
            ; sp=0  sp=1    ov 
            ldx #2
            stx stack.pointer
            
            lda #'a'
            jsr stack.push_word
            if_false stack_overflow
            
            ;--------------------------------------------------------------- 
            
            rts
            
stack_overflow

            lda #'0'
            sta 1024
            
            rts
            
    .pend

.pend

;;;
;;
;

