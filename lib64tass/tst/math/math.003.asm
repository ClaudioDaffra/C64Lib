

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

    au16    .word    1
    bu16    .word    2

    as16    .sint   -1
    bs16    .sint    2

    debug_carry .proc
        lda #'0'
        adc #0
        
        rts
    .pend
    
    start	.proc

            ;   program
 
            ;  .................................... compare u16
            ;  0111
            ;  0111

            .load_zpWord0    au16
            .load_zpWord1    bu16
            ; 1 >= 2
            jsr math.u16_cmp_ge
            jsr debug_carry
            sta 1024
            .load_zpWord0    au16
            .load_zpWord1    au16
            ; 1 >= 1
            jsr math.u16_cmp_ge
            jsr debug_carry
            sta 1025

            .load_zpWord0    au16
            .load_zpWord1    bu16
            ; 1 <= 2
            jsr math.u16_cmp_le
            jsr debug_carry
            sta 1026
            .load_zpWord0    au16
            .load_zpWord1    au16
            ; 1 <= 1
            jsr math.u16_cmp_le
            jsr debug_carry
            sta 1027
            
            ;  .................................... compare s16

            .load_zpWord0    as16
            .load_zpWord1    bs16
            ;  -1 >= 2
            jsr math.s16_cmp_ge
            jsr debug_carry
            sta 1024+40
            .load_zpWord0    as16
            .load_zpWord1    as16
            ;  -1 >= -1
            jsr math.s16_cmp_ge
            jsr debug_carry
            sta 1025+40

            .load_zpWord0    as16
            .load_zpWord1    bs16
            ; -1 <= 2
            jsr math.s16_cmp_le
            jsr debug_carry
            sta 1026+40
            .load_zpWord0    as16
            .load_zpWord1    as16
            ;  -1 <= -1
            jsr math.s16_cmp_le
            jsr debug_carry
            sta 1027+40
            
            rts
 

    .pend

.pend

;;;
;;
;

