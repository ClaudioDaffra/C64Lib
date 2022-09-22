
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
.include "../lib/libConv.asm"

;--------------------------------------------------------------- main

main	.proc

    temp    .byte   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;   char
    
    start	.proc

            ;   program

            ; ---------------------------- clear screen, go 0,0 (home)
            
            lda #' '
            jsr txt.clear_screen_chars
            
            lda #char.home
            jsr sys.CHROUT

            ; ---------------------------- input string
            
            load_address_ay temp
            jsr std.input_string
            
            load_address_ay temp
            jsr std.print_string

            ; ---------------------------- input string max
            
            load_address_ay temp
            ldx #5
            jsr std.input_string_max
            
            load_address_ay temp
            jsr std.print_string
            
            
            rts

    .pend

.pend

;;;
;;
;









