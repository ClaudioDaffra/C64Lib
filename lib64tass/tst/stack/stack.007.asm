

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
            
            ;-----------------------------------------------------   byte

            jsr stack.debug
            
            lda #char.nl
            jsr c64.CHROUT

            lda #13
            sec
            jsr std.print_u8_bin
            
            lda #char.nl
            jsr c64.CHROUT
            
            lda #13
            jsr stack.push_byte
            
            lda #26
            sec
            jsr std.print_u8_bin
            lda #26
            jsr stack.push_byte
            
            lda #char.nl
            jsr c64.CHROUT
            
            jsr stack.debug

            lda #char.nl
            jsr c64.CHROUT
            
            jsr stack.bitand_b

            jsr stack.pop_byte
            jsr std.print_u8_bin

            lda #char.nl
            jsr c64.CHROUT
            
            jsr stack.debug
            
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

