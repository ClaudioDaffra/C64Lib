

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

    start	.proc

            ;   program
            
            jsr stack.debug
            
            ;-------------------------------------------- operation with stack
            ; 401/27=14     -   14*27+23=401
            
            load_imm_ay #401
            jsr stack.push_word

            load_imm_ay #27
            jsr stack.push_word

            jsr stack.mod_uw

            jsr stack.pop_word
            
            jsr std.print_u16_dec

            jsr stack.debug
            
            lda #char.nl
            jsr c64.CHROUT
            
            ;-------------------------------------------- operation with stack
            ;   23/6=3    = 3*6+5 =23
            
            lda #char.nl
            jsr c64.CHROUT
            
            lda #23
            jsr stack.push_byte

            load_imm_ay #6
            jsr stack.push_byte

            jsr stack.mod_ub

            jsr stack.pop_byte
            
            jsr std.print_u8_dec

            jsr stack.debug
            
            lda #char.nl
            jsr c64.CHROUT
            
            rts
    .pend

.pend

;;;
;;
;

