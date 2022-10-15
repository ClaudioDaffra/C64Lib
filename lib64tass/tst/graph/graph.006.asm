
; #################################################
;
;   compile with 
;
;   64tass.exe -D c64.bitmap_addr=$E000 -D c64.screen_addr=$CC00 -C -a -B -i %1 -o %1.prg
;
;
;   64tass.exe 
;               -D c64.bitmap_addr=$E000 
;               -D c64.screen_addr=$CC00 
;               -C -a -B -i %1 
;               -o %1.prg
;
; #################################################

.cpu  '6502'
.enc  'none'

; ---- basic program with sys call ----

; [start address]

* = $0801
    ;           [line]
    .word  (+), 2022
    ;      [sys]                                     [rem]     [desc]
    .null  $9e, format(' %d ', program_entry_point), $3a, $8f, ' prg'
+   .word  0

program_entry_point	; assembly code starts here

	jmp main.start

;--------------------------------------------------------------- lib

.include "../../lib/libC64.asm"

;--------------------------------------------------------------- main

main	.proc

    start	.proc
    
;jmp xxx

                ;**********
                ;   320x200
                ;**********
                
                ;jsr graph.bank3.hires_bitmap_E000_screen_CC00_ON
                jsr graph.bank3.high.on

                lda #color.yellow        ;   graph high color    (0,1)
                sta graph.foreground_color
                
                lda #color.red
                sta graph.background_color

                jsr graph.high.set_color    

                jsr graph.bank3.bitmap_clear
                
                ; ################################# draw

                lda #1
                sta graph.color_number  ;   color number 0,1
        
                jsr draw

                ; ################################# draw
rts
                ;jsr graph.bank3.bitmap_E000_screen_CC00_OFF
                jsr graph.bank3.high.off
                
                rts


xxx

                ;**********
                ;   160x200
                ;**********
                
                ;jsr graph.bank3.multi_bitmap_E000_screen_CC00_ON
                jsr graph.bank3.low.on

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

                jsr graph.bank3.bitmap_clear

                ; ################################# draw
                
                lda #3
                sta graph.color_number  ;   color number 0,1,2,3
        
                jsr draw

                ; ################################# draw
                
rts
                ;jsr graph.bank3.bitmap_E000_screen_CC00_OFF
                jsr graph.bank3.low.off

                rts

                ; ################################# CHECK RANGE X,Y,LENGTH

                draw    .proc
                
                    lda #1
                    sta graph.pixel.checkXY
                
                    ;   ay ->   zpWord0
                    .graph_imm_x #1
                    ;   y  ->    zpy
                    .graph_imm_y #1
                    ;  ay   ->  ay 
                    .load_imm_ay #200 ;   length

                    jsr graph.horizontal_line

                    ;   ay ->   zpWord0
                    .graph_imm_x #1
                    ;   y  ->    zpy
                    .graph_imm_y #1
                    ;  ay   ->  ay 
                    .load_imm_ay #20
                    ;lda #20 ;   length
                    
                    jsr graph.vertical_line

                    lda #0
                    sta graph.pixel.checkXY
                    
                    rts
                
                .pend
                
                ; #################################
                
    .pend

.pend

;;;
;;
;

