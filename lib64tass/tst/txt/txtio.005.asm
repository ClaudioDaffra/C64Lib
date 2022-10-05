
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

            ; ---------------------------- print string
            
            load_address_ay stringa
            jsr std.print_string


            ; ------------------------ sec scroll text & color
            ; ------------------------ clc scroll text

            jsr txt.screen_scroll_left
            jsr txt.screen_scroll_down
            jsr txt.screen_scroll_right
            jsr txt.screen_scroll_up

            ; ------------------------ clc scroll text

            lda  #char.nl
            jsr  sys.CHROUT
            
            rts

    .pend

.pend

;;;
;;
;









