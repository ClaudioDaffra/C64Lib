

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
            
            ;-------------------------------------------- sign

            ; 401/27=14     -   14*27+((23))=401
            
            load_imm_zpWord0 #401
            load_imm_ay  #27

            jsr math.mod_uw ;   return ay remainder

            jsr std.print_u16_dec
 
            lda #char.nl
            jsr c64.CHROUT

            ;-------------------------------------------- operation with stack
            ;   23/6=3    = 3*6+((5)) =23

            lda #23
            ldy #6

            jsr math.mod_ub

            jsr std.print_u8_dec    ;   return a remainder

            lda #char.nl
            jsr c64.CHROUT
            
            rts
    .pend

.pend

;;;
;;
;

