

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

    save_sp .byte 0
    
    start	.proc

            ;   program
 
            ;--------------------------------------------------------------- clear
 
            jsr c64.CLEARSCR

            ;---------------------------------------------------------------
            
            lda stack.pointer
            sta save_sp
            
            ;-----------------------------------------------------   ubyte

            jsr stack.debug
 
            lda #char.nl
            jsr c64.CHROUT

            lda #26
            sec
            jsr std.print_u8_dec
            
            lda #char.nl
            jsr c64.CHROUT
            
            lda #26
            jsr stack.push_byte
            
            lda #2
            sec
            jsr std.print_u8_dec
            lda #2
            jsr stack.push_byte
            
            lda #char.nl
            jsr c64.CHROUT
            
            jsr stack.debug

            lda #char.nl
            jsr c64.CHROUT
            
            ;-------------------------------------------------
            
            jsr stack.idiv_ub
            
            ;-------------------------------------------------
            
            jsr stack.pop_byte
            jsr std.print_u8_dec

            lda #char.nl
            jsr c64.CHROUT
            
            jsr stack.debug

            lda #char.nl
            jsr c64.CHROUT
            
            ;-----------------------------------------------------   sbyte

            lda #char.nl
            jsr c64.CHROUT
            
            jsr stack.debug
            
            lda #char.nl
            jsr c64.CHROUT

            lda #-26
            sec
            jsr std.print_s8_dec
            
            lda #char.nl
            jsr c64.CHROUT
            
            lda #-26
            jsr stack.push_byte
            
            lda #3
            sec
            jsr std.print_s8_dec
            
            lda #3
            jsr stack.push_byte
            
            lda #char.nl
            jsr c64.CHROUT
            
            jsr stack.debug

            lda #char.nl
            jsr c64.CHROUT
            
            ;-------------------------------------------------
            
            jsr stack.idiv_b

            ;-------------------------------------------------

            jsr stack.pop_byte
            jsr std.print_s8_dec

            lda #char.nl
            jsr c64.CHROUT
            
            jsr stack.debug  
            
            lda save_sp
            sta stack.pointer
            tax

            rts
            
    .pend

.pend

;;;
;;
;

