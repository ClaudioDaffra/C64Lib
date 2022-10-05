

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

;--------------------------------------------------------------- sub

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

    save_sp .byte 0
    
    start	.proc

            ;   program
 
            ;--------------------------------------------------------------- clear
 
            jsr sys.CLEARSCR

            ;---------------------------------------------------------------
            
            lda stack.pointer
            sta save_sp
            
            ;-----------------------------------------------------   byte

            lda #char.nl
            jsr sys.CHROUT

            lda #13
            sec
            jsr std.print_u8_bin

            lda #char.nl
            jsr sys.CHROUT
            
            lda #13
            jsr stack.push_byte
            
            jsr stack.neg_b
            
            jsr stack.pop_byte
            
            sec
            jsr std.print_u8_bin

            ;----------------------------------------------------- word

            lda #char.nl
            jsr sys.CHROUT
            
            load_imm_ay #123
            sec
            jsr std.print_u16_bin

            lda #char.nl
            jsr sys.CHROUT
            
            load_imm_ay #123
            jsr stack.push_word
            
            jsr stack.neg_w
            
            jsr stack.pop_word
            
            sec
            jsr std.print_u16_bin

            ;----------------------------------------------------- word

            lda #char.nl
            jsr sys.CHROUT
            
            load_imm_ay #123
            sec
            jsr std.print_u16_bin

            lda #char.nl
            jsr sys.CHROUT
            
            load_imm_ay #123
            jsr stack.push_word
            
            jsr stack.inv_w
            
            jsr stack.pop_word
            
            sec
            jsr std.print_u16_bin
            
            ;-----------------------------------------------------   
            
            lda save_sp
            sta stack.pointer
            tax

            rts
            
    .pend

.pend

;;;
;;
;

