

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

            ;jsr debug_stack

            ;--------------------------------------------------------------- 
 
            load_imm_ay #$0400
            jsr stack.push_word
            
            lda #char.a
            ;jsr stack.write_byte_to_address_on_stack
            jsr stack.poke
            
            ;--------------------------------------------------------------- 

            ;jsr stack.read_byte_from_address_on_stack
            jsr stack.peek
            
            sta 1025

            ;--------------------------------------------------------------- 

            rts
            
    .pend

.pend

;;;
;;
;

