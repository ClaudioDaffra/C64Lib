
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

.include "../lib/libC64.asm"
.include "../lib/libMath.asm"
.include "../lib/libSTDIO.asm"

;--------------------------------------------------------------- main

main	.proc

    start	.proc

            ; ------------------------------------- std mode
            
            lda #color.black
            sta screen.background_color
            
            lda #color.green
            sta screen.foreground_color
            
            lda #color.grey
            sta screen.border_color 

            jsr c64.set_text_mode_standard_on

            lda #' '
            jsr txt.clear_screen_chars
            
            ;lda #char.clear_screen
            ;jsr sys.CHROUT
            
            lda #3
            sta screen.row
            lda #5
            sta screen.col 
            
            lda #1
            sta screen.char

            jsr txt.set_char           
            jsr txt.set_foreground_color   
            
            ; ----------------------------
            
            lda #5
            sta screen.row
            lda #7
            sta screen.col 
            
            jsr txt.set_char
            jsr txt.set_foreground_color 
            
            ; ----------------------------
            
            inc screen.row
            inc screen.col

            jsr txt.set_cc
            
            rts

    .pend

.pend

;;;
;;
;









