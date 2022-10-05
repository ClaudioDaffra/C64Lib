

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
    ;               ay      height
    ;               zpWord0 X
    ;               zpy     Y
    ;               zpWord2 (lengh counter)
    
    horizontal_line    .proc

        sta zpWord2     ;   salva la lunghezza ( w0,w1,w2 used )
        sty zpWord2+1
        
        sta zpa
        beq +
    -
        jsr graph.pixel
        
        ;   zpWord  (++x)       ex  0001    (1)

        u16_add_1   zpWord0
        
        ;  zpword  (--length)   ex  0140    (320)

        u16_sub_1   zpWord2
        
        if_u16_gt_0 zpWord2 ,   -
        
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
jmp xxx        
        ;
        
        graph_imm_x #1
        graph_imm_y #1
        
        lda #10 ;   length

        jsr vertical_line
        
        ;............................................................   horizontal_line 
xxx   
        graph_imm_x #1
        graph_imm_y #1
        
        load_imm_ay #257 ;   length
        
        jsr horizontal_line
        
 
rts

        jsr graph.high.off
        

        rts
        
    .pend

.pend

;;;
;;
;

