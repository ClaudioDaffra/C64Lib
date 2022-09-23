
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
.include "../../lib/libMath.asm"
.include "../../lib/libSTDIO.asm"

;--------------------------------------------------------------- main

main	.proc

    start	.proc

            lda #color.light_grey
            sta screen.border_color 
            
            lda #color.yellow
            sta screen.background_color_0
            
            lda #color.red
            sta screen.background_color_1
            
            lda #color.white
            sta screen.background_color_2
            
            lda #color.green
            sta screen.background_color_3
            
            lda #color.cyan
            sta screen.foreground_color

            jsr c64.set_text_mode_extended_on
            
            lda #' '
            jsr txt.clear_screen_chars

            ;lda #color.black
            ;jsr txt.clear_screen_colors
            
            lda #char.a
            sta screen.char
            
            ; ----------------------------  white,red
            
            lda #2
            sta screen.background_color_number
            lda #5
            sta screen.row
            lda #7
            sta screen.col 
            jsr txt.set_char
            
            lda #color.red
            sta screen.foreground_color
            jsr txt.set_foreground_color
            
            ; ---------------------------- green,red
            
            lda #3
            sta screen.background_color_number
            lda #5
            sta screen.row
            lda #8
            sta screen.col 
            jsr txt.set_char

            lda #color.red
            sta screen.foreground_color
            jsr txt.set_foreground_color
            
            ; ---------------------------- white,red
            
            inc screen.row
            inc screen.col

            lda #2
            sta screen.background_color_number
            
            lda #'b'
            sta screen.char
            jsr txt.set_char_with_color_number
            sta screen.char
            
            jsr txt.set_cc

            
            rts

    .pend

.pend

;;;
;;
;









