

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
.include "../../lib/libString.asm"


;--------------------------------------------------------------- main


main	.proc

    s1  .null   "0123456789abcdef"  ;   16 byte

    start	.proc

            ;   program
 
            ;   ...................................... copy string at 0,0

            lda #color.white
            jsr txt.clear_color

            jsr txt.clear_screen
            
            ldx #0
            ldy #0
            sta screen.col
            jsr txt.set_cursor_pos_xy
            
            load_address_ay s1
            jsr std.print_string

            lda #char.nl
            jsr sys.CHROUT

            
            ;   ...................................... copy string row below
            
            ;   copia 8 caratteri
            
            load_address_zpWord0 1024
            load_address_zpWord1 1064
            load_imm_ay #08
            jsr mem.copy
            
            rts
 

    .pend

.pend

;;;
;;
;

