

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

    au16   .word    1
    bu16   .word    2

    as16   .sint   -1
    bs16   .sint    2

    debug_carry .proc
        lda #'0'
        adc #0
        rts
    .pend
    
    start	.proc

            ;   program
 
            ;  .................................... compare u16  ?= 0
            ;  001
            ;  001
            
            .load_zpWord0    au16
            .load_zpWord1    bu16

            jsr math.u16_cmp_eq
            jsr debug_carry
            sta 1024

            jsr math.u16_cmp_gt
            jsr debug_carry
            sta 1025

            jsr math.u16_cmp_lt
            jsr debug_carry
            sta 1026

            .load_zpWord0    as16
            .load_zpWord1    bs16

            jsr math.s16_cmp_eq
            jsr debug_carry
            sta 1024+40

            jsr math.s16_cmp_gt
            jsr debug_carry
            sta 1025+40

            jsr math.s16_cmp_lt
            jsr debug_carry
            sta 1026+40
            
            rts
 

    .pend

.pend

;;;
;;
;

