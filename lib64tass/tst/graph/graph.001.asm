

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


            graph_x  .macro
                lda <\1
                sta zpWord0
                lda >\1
                sta zpWord0+1
            .endm
            
            graph_y  .macro
                lda \1
                sta zpy
            .endm
            graph_color  .macro
                lda \1
                sta zpa
            .endm

        
        
main	.proc

    start	.proc

        jsr graph.high.on       ;   320x200
 
        jsr graph.clear         ;   clear

        lda #color.yellow       ;   graph high color    (0,1)
        sta graph.foreground_color
        lda #color.red
        sta graph.background_color

        jsr graph.high.set_color


        lda #1
        sta graph.color_number  ;   color number 0,1

        graph_x #0
        graph_y #0
        jsr graph.pixel
        
        graph_x #1
        graph_y #1
        jsr graph.pixel

        graph_x #3
        graph_y #3
        jsr graph.pixel
        
        graph_x #5
        graph_y #5
        jsr graph.pixel

        graph_x #7
        graph_y #7
        jsr graph.pixel

        graph_x #319
        graph_y #199
        jsr graph.pixel

        lda #0
        sta graph.color_number  ;   erase 5,5

        graph_x #5
        graph_y #5
        jsr graph.pixel
        
rts

        jsr graph.high.off
        

        rts
        
    .pend

.pend

;;;
;;
;

