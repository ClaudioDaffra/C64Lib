

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

;--------------------------------------------------------------- pixel

        ;   N   =   graph.color_number   ;  color number
        ;   Y   =   zpy                  ;  coord y
        ;   X   =   zpWord0              ;  coord x
        ;   P   =   zpWord1              ;  graph P address
        
;*******
;       sub
;*******

    ;............................................................ horizontal_line
    ;
    ;   input   :
    ;               a       height
    ;               zpWord0 X
    ;               zpy     Y
        
    horizontal_line    .proc

        sta  zpa
        beq  +
    -
        jsr  graph.pixel

        clc
        lda  #1
        adc  zpWord0
        sta  zpWord0
        lda  #0
        adc  zpWord0+1
        sta  zpWord0+1
        
        dec  zpa
        bne  -
    +
        rts

    .pend

    vertical_line    .proc

    ;............................................................ vertical_line
    ;
    ;   input   :
    ;               a       height
    ;               zpWord0 X
    ;               zpy     Y

        sta  zpa
        beq  +
    -
        jsr  graph.pixel

        inc  zpy
        
        dec  zpa
        bne  -
    +
        rts

    .pend
    
;--------------------------------------------------------------- main


main	.proc

    start	.proc

        jsr graph.high.on       ;   320x200
 
        jsr graph.clear         ;   clear

        lda #color.white       ;   graph high color    (0,1)
        sta graph.foreground_color
        
        lda #color.black
        sta graph.background_color

        jsr graph.high.set_color

        ;............................................................   vertical_line  
    
        lda #1
        sta graph.color_number  ;   color number 0,1
        
        ;
        
        graph_imm_x #1
        graph_imm_y #1
        
        lda #10 ;   length

        jsr vertical_line
        
        ;............................................................   horizontal_line 
    
        graph_imm_x #1
        graph_imm_y #1
        
        lda #10 ;   length
        
        jsr horizontal_line
        
 
rts

        jsr graph.high.off
        

        rts
        
    .pend

.pend

;;;
;;
;

