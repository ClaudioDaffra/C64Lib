
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

    n1      .word  32768
    stringa .null "hello"

    start	.proc

            ;   program
            ; ---------------------------- clear screen, go 0,0 (home)
            lda #' '
            jsr txt.clear_screen_chars
            lda #char.home
            jsr c64.CHROUT
            
            ; ---------------------------- print string

            .load_address_ay stringa
            jsr std.print_string

            ; ---------------------------- print char ( swap h with b )
            lda #0
            sta screen.row
            lda #0
            sta screen.col 
            lda #char.b
            sta screen.char
            jsr txt.set_char

            lda #color.white
            sta screen.foreground_color
            jsr txt.set_foreground_color

            ; ---------------------------- get char b
            
            lda #0
            sta screen.row
            lda #0
            sta screen.col 
            jsr txt.get_char
            sta screen.char
            
            ; ---------------------------- print 1,1 get(a)
            lda #0
            sta screen.row
            lda #10
            sta screen.col 
            jsr txt.set_char
            
            ; ---------------------------- \n \n \n 
            
            lda #char.nl
            jsr c64.CHROUT
            jsr c64.CHROUT
            jsr c64.CHROUT

            ; ---------------------------- get fore ground color 
            
            lda #0
            sta screen.row
            lda #0
            sta screen.col
            
            jsr txt.get_foreground_color
            
            jsr std.print_u8_dec
            
            rts

    .pend

.pend

;;;
;;
;









