

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

;--------------------------------------------------------------- sub

;--------------------------------------------------------------- main

main	.proc

    start	.proc


            lda #3
            jsr math.get_rand_num_byte
            jsr std.print_u8_dec

            lda #char.nl
            jsr c64.CHROUT

            .load_imm_ay #1000
            jsr math.get_rand_num_word
            jsr std.print_u16_dec
            
            lda #char.nl
            jsr c64.CHROUT
            
            rts
    .pend

.pend

;;;
;;
;

