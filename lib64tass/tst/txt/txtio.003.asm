
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

    s8    .char -123
    s16   .sint -25031
    s16p  .sint  25031
    
    start	.proc

            ;   program
            
            ; .................................... print signed dec -

            lda #-123
            jsr std.print_s8_dec
            
            lda #' '
            jsr c64.CHROUT

            .load_var_ay s16
            jsr std.print_s16_dec
            
            lda #' '
            jsr c64.CHROUT

            .load_imm_ay #-32765
            jsr std.print_s16_dec
            
            lda #char.nl
            jsr c64.CHROUT

            ; .................................... print signed +

            lda #123
            jsr std.print_s8_dec

            lda #' '
            jsr c64.CHROUT
            
            .load_imm_ay #25031
            jsr std.print_s16_dec

            ; .................................... print signed 8

            lda #char.nl
            jsr c64.CHROUT
            
            sec
            lda #-123
            jsr std.print_s8_hex

            lda #' '
            jsr c64.CHROUT

            sec
            lda #-123
            jsr std.print_s8_bin

            lda #' '
            jsr c64.CHROUT
            
            lda #-123
            jsr std.print_s8_dec

            ; .................................... print signed 16

            lda #char.nl
            jsr c64.CHROUT

            lda #char.nl
            jsr c64.CHROUT
            
            sec ;       $61c7
            .load_imm_ay #25031
            jsr std.print_s16_hex

            lda #' '
            jsr c64.CHROUT

            sec         ; %0110000111000111
            .load_imm_ay #25031
            jsr std.print_s16_bin

            lda #' '
            jsr c64.CHROUT
            ;           +25031
            .load_var_ay s16p
            jsr std.print_s16_dec
            
            rts

    .pend

.pend

;;;
;;
;









