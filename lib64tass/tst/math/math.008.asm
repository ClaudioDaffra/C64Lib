

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

            ;-------------------------------------------- math
 
            lda #char.nl
            jsr c64.CHROUT

            ;-------------------------------------------- square unsigned

            ;   square(27) = 729
            
            load_imm_ay #27
            
            jsr math.square
            
            jsr std.print_u16_dec

            ;-------------------------------------------- square unsigned

            lda #char.nl
            jsr c64.CHROUT
            
            ;   sqrt(81) = 9
            
            load_imm_zpWord0 #81
            
            jsr math.sqrt
            
            jsr std.print_u8_dec

            ;-------------------------------------------- stack sqrt

            lda #char.nl
            jsr c64.CHROUT

            load_imm_ay #81
            jsr stack.push_word
            
            jsr stack.sqrt
            
            jsr stack.pop_byte      ;   remeber stack.hi+1,x    ,   stack.lo+1,x !
                        
            jsr std.print_u8_dec
            
            rts
    .pend

.pend

;;;
;;
;

