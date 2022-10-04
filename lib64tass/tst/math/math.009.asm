

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

;--------------------------------------------------------------- sub

;--------------------------------------------------------------- main

main	.proc

    start	.proc

            ;   program

            ;-------------------------------------------- math
 
            lda #char.nl
            jsr sys.CHROUT

            ;-------------------------------------------- compare signed
            ;   -128 no
            
            lda #-128
            cmp #0

            s8_cmp_le   le
            s8_cmp_ge   ge
            s8_cmp_lt   lt
            s8_cmp_gt   gt
            s8_cmp_eq   eq
            
            rts

eq
            lda #'='
            sta 1025
            rts

lt
            lda #'<'
            sta 1024
            rts

gt
            lda #'>'
            sta 1024
            rts

le
            lda #'<'
            sta 1024
            lda #'='
            sta 1025
            rts

ge
            lda #'>'
            sta 1024
            lda #'='
            sta 1025
            rts
            
            
    .pend

.pend

;;;
;;
;

