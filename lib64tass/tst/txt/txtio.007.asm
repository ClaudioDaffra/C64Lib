
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

    temp    .byte   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;   char
    
    start	.proc

            ;   program

            ; ---------------------------- clear screen kernal
            
            jsr sys.SCREEN_CLEAR
            jsr sys.SCREEN_HOME

            ; ---------------------------- input string
            
            load_address_ay temp
            jsr std.input_string
            
            load_address_ay temp
            jsr std.print_string

            ; ---------------------------- input string max

            lda #char.nl
            jsr sys.CHROUT
            
            load_address_ay temp
            ldx #5
            jsr std.input_string_max

            lda #' '
            jsr sys.CHROUT
            
            load_address_ay temp
            jsr std.print_string

            lda #' '
            jsr sys.CHROUT
            
            lda #'['
            jsr sys.CHROUT
            
            ; ---------------------------- print string kernal

            load_address_ay temp
            jsr sys.STROUT

            lda #']'
            jsr sys.CHROUT
            
            rts

    .pend

.pend

;;;
;;
;









