

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
.include "../../lib/libGraph.asm"

;--------------------------------------------------------------- main

main	.proc

    start	.proc

        jsr graph.hires_on
 
        jsr graph.clear

        lda #color.yellow
        sta screen.foreground_color
        lda #color.red
        sta screen.background_color

        jsr graph.hires_color

        ; plot
        lda #255
        sta 8192
        
rts

        jsr graph.hires_off
        

        rts
        
    .pend

.pend

;;;
;;
;

