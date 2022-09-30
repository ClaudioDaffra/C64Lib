

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

;       border      $d020
;       color 0     $d021
;       color 12    $0400   screen char
;       color 3     $d800

main	.proc

    start	.proc

        jsr graph.low.on

        lda #color.red
        sta screen.border_color
        jsr txt.set_border_color
        
        lda #color.white
        sta screen.background_color_0
        lda #color.red
        sta screen.background_color_1
        lda #color.green
        sta screen.background_color_2
        lda #color.blue
        sta screen.background_color_3
        
        jsr graph.low.set_color

        jsr graph.clear

        ;
        
        lda #%11000110
        sta 8192
        lda #%11000110
        sta 8193
        lda #%11000110
        sta 8194
        lda #%11000110
        sta 8195
rts

        jsr graph.low.off
        lda #color.white
        sta 53281
        lda #char.a
        sta 1024
        

        
        rts
        
    .pend

.pend

;;;
;;
;

