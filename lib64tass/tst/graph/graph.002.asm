

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
        sta graph.color0
        
        lda #color.red
        sta graph.color1
        
        lda #color.green
        sta graph.color2
        
        lda #color.blue
        sta graph.color3
        
        jsr graph.low.set_color

        jsr graph.clear

        ;

        lda #1
        sta graph.color_number  ;   color number 1
        graph_imm_x #0
        graph_imm_y #0
        jsr graph.pixel
        
        lda #2
        sta graph.color_number  ;   color number 1
        graph_imm_x #1
        graph_imm_y #1
        jsr graph.pixel

        lda #3
        sta graph.color_number  ;   color number 2
        graph_imm_x #3
        graph_imm_y #3
        jsr graph.pixel
        
        lda #0
        sta graph.color_number  ;   color number 0
        graph_imm_x #5
        graph_imm_y #5
        jsr graph.pixel

        lda #1
        sta graph.color_number  ;   color number 3
        graph_imm_x #7
        graph_imm_y #7
        jsr graph.pixel

        lda #2
        sta graph.color_number  ;   color number 1
        graph_imm_x #159
        graph_imm_y #199
        jsr graph.pixel
        
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

