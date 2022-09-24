
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
.include "../../lib/libConv.asm"

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
            jsr sys.CHROUT

            load_var_ax s16
            jsr std.print_s16_dec
            
            lda #' '
            jsr sys.CHROUT

            load_imm_ax #-32765
            jsr std.print_s16_dec
            
            lda #char.nl
            jsr sys.CHROUT

            ; .................................... print signed +

            lda #123
            jsr std.print_s8_dec

            lda #' '
            jsr sys.CHROUT
            
            load_imm_ax #25031
            jsr std.print_s16_dec

            ; .................................... print signed 8

            lda #char.nl
            jsr sys.CHROUT
            
            sec
            lda #-123
            jsr std.print_s8_hex

            lda #' '
            jsr sys.CHROUT

            sec
            lda #-123
            jsr std.print_s8_bin

            lda #' '
            jsr sys.CHROUT
            
            lda #-123
            jsr std.print_s8_dec

            ; .................................... print signed 16

            lda #char.nl
            jsr sys.CHROUT

            lda #char.nl
            jsr sys.CHROUT
            
            sec ;       $61c7
            load_imm_ay #25031
            jsr std.print_s16_hex

            lda #' '
            jsr sys.CHROUT

            sec
            load_imm_ay #25031
            jsr std.print_s16_bin

            lda #' '
            jsr sys.CHROUT
            
            load_var_ax s16p
            jsr std.print_s16_dec
            
            rts

    .pend

.pend

;;;
;;
;









