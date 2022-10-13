

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

        ;--------------------------------------------------------------- horizontal_line
        ;
        ;       zpWord0 x
        ;       ay      length
        ;       zpy     y
        
        horizontal_line    .proc
        
            ;   maxLength
            sta lengthMax       ;   lunghezza massima
            sty lengthMax+1
            
            ; coordX
            lda zpWord0
            sta coordX
            lda zpWord0+1
            sta coordX+1

            lda #0
            sta length
            lda #0
            sta length+1
            
            ;   coordy
            ldy zpy
            sty coordY

        loop
        
            u16_add_1   coordX
            copy_u16    zpWord0,coordX

            ldy coordY
            sty zpy

            jsr graph.pixel ;   (zpy ,zpWord0)

            u16_add_1   length

            lda length+1
            cmp lengthMax+1
            bne +
            lda length+0
            cmp lengthMax+0
        + 
            bcc loop  ;   lower
            bne loop  ;   higher
            ;beq end   ;   same

            rts
            
        length      .word   0
        lengthMax   .word   0
        coordY      .byte   0
        coordX      .word   0
        
        .pend
 
    ;............................................................ vertical_line
    ;
    ;   input   :
    ;               a       height
    ;               zpWord0 X
    ;               zpy     Y
  
    vertical_line    .proc

        sta coordY
        
        copy_u16 coordX,zpWord0

        lda coordY
        
        beq  +
    -
        copy_u16 zpWord0,coordX
        
        ldy coordY
        sty zpy
        
        jsr  graph.pixel

        dec  coordY
        
        bne  -
    +
        rts
    coordY   .byte   0
    coordX   .word   0
    .pend
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

        jsr graph.clear

        ;............................................................   graph.color_number  
    
        lda #1
        sta graph.color_number  ;   color number 0,1,2,3

        ;............................................................   horizontal_line 

        ;   ay ->   zpWord0
        graph_imm_x #1
        ;   y  ->    zpy
        graph_imm_y #1
        ;  ay   ->  ay 
        load_imm_ay #20 ;   length

        jsr horizontal_line

        lda #2
        sta graph.color_number  ;   color number 0,1,2,3
        
        ;   ay ->   zpWord0
        graph_imm_x #1
        ;   y  ->    zpy
        graph_imm_y #1
        ;  ay   ->  ay 
        load_imm_ay #20 ;   length
        
        jsr vertical_line

rts
        
        jsr graph.low.off


        rts
        
    .pend

.pend

;;;
;;
;

