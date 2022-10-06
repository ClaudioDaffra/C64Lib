

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

            ;   program
            
            ;-------------------------------------------- abs byte
 
            lda #-15
            jsr std.print_s8_dec
            
            lda #char.nl
            jsr sys.CHROUT

            lda #-15
            jsr math.abs_b
 
            jsr std.print_u16_dec

            lda #char.nl
            jsr sys.CHROUT
            
            ;-------------------------------------------- abs word
 
            load_imm_ay #-15
            jsr std.print_s16_dec
            
            lda #char.nl
            jsr sys.CHROUT

            load_imm_ay #-15
            jsr math.abs_w
 
            jsr std.print_u16_dec
            
            rts
    .pend

.pend

;;;
;;
;

