

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

        load_imm_zpWord0    #$2000
        jsr graph.bitmap_clear
        
        ;............................................................   graph.color_number  
    
        lda #1
        sta graph.color_number  ;   color number 0,1,2,3

        ;............................................................   horizontal_line 

        ;   ay ->   zpWord0
        .graph_imm_x #1
        ;   y  ->    zpy
        .graph_imm_y #1
        ;  ay   ->  ay 
        .load_imm_ay #20 ;   length

        jsr graph.horizontal_line

        lda #2
        sta graph.color_number  ;   color number 0,1,2,3
        
        ;   ay ->   zpWord0
        .graph_imm_x #1
        ;   y  ->    zpy
        .graph_imm_y #1
        ;  ay   ->  ay 
        .load_imm_ay #20 ;   length
        
        jsr graph.vertical_line

rts
        
        jsr graph.low.off


        rts
        
    .pend

.pend

;;;
;;
;

