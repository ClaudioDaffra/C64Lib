

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

;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

main	.proc

    start	.proc

            ;   program
 
            lda #' '
            ldy #color.green
            jsr txt.fill_screen

            ; .............................................. store
            
            load_imm_ay #$3031
            lda #'0'
            sta 1024
            ldy #'1'
            sty 1025
            store_imm_zpWord0   #$0400

            ; .............................................. peekw
            
            load_imm_ay #1024
            jsr c64.peekw
            ;   (a,y) := (word)*(zpWord0)
            switch_ay

            pha
            tya
            jsr txt.print_u8_hex
            pla
            jsr txt.print_u8_hex
            
            ;   3031    -> '0','1'

            ; .............................................. pokew

            lda #char.nl
            jsr c64.CHROUT
            
            store_imm_zpWord0   #$0405
            jsr txt.print_u16_hex
            
            load_imm_ay #$3031
            switch_ay
            ;  *(zpWord0) := *(ay)
            jsr c64.pokew

            ; .............................................. pokew
            ;   3031 01
            ;   0405
            rts
 

    .pend

.pend

;;;
;;
;

