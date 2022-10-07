
.cpu  '6502'
.enc  'none'

; ---- basic program with sys call ----

; [start address]

* = $0801
    ;           [line]
	.word  (+), 2022
    ;      [sys]                                     [rem]     [desc]
	.null  $9e, format(' %d ', program_entry_point), $3a, $8f, ' prg'
+	.word  0

program_entry_point	; assembly code starts here

	jmp main.start

;--------------------------------------------------------------- lib

.include "../../lib/libC64.asm"

;--------------------------------------------------------------- main

main	.proc

    start	.proc

            ;   program

            ; ---------------------------- clear screen, go 0,0 (home)
            
            lda #' '
            jsr txt.clear_screen_chars
            
            lda #char.home
            jsr c64.CHROUT

            ; ---------------------------- set cur pos
            
            lda #1
            sta screen.row
            sta screen.col
            
            jsr txt.set_cursor_pos
            
            lda #'a'
            jsr c64.CHROUT

            ; ---------------------------- get cur pos

            jsr txt.get_cursor_pos
            
            lda screen.row
            jsr std.print_u8_dec
            
            lda #'/'
            jsr c64.CHROUT
            
            lda screen.col
            jsr std.print_u8_dec
            
            ; ---------------------------- get screen width / height
            
            lda #char.nl
            jsr c64.CHROUT      

            jsr txt.get_screen_dim
              
            lda screen.width
            jsr std.print_u8_dec
            
            lda #'/'
            jsr c64.CHROUT
            
            lda screen.height
            jsr std.print_u8_dec
            
            
            rts

    .pend

.pend

;;;
;;
;









