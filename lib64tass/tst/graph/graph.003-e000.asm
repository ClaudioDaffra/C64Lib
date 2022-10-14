
; #################################################
;
;   compile with 
;
;   64tass.exe -D c64.bitmap_addr=$bank3 -D c64.screen_addr=$C000 -C -a -B -i %1 -o %1.prg
;
;
;   64tass.exe 
;               -D c64.bitmap_addr=$bank3 
;               -D c64.screen_addr=$C000 
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

                ;**********
                ;   320x200
                ;**********
                
                jsr graph.bank3.hires_bitmap_E000_screen_CC00_ON

                lda #color.yellow           ;   graph high color    (0,1)
                sta graph.foreground_color
                
                lda #color.red
                sta graph.background_color

                jsr graph.high.set_color    

                jsr graph.bank3.bitmap_clear
                
                lda #1
                sta graph.color_number      ;   color number 0,1
        
                jsr draw

                ;jsr graph.bank3.bitmap_E000_screen_CC00_OFF
 
                rts

                ; ################################# sub draw

                        draw    .proc
                        
                            ;   ay ->   zpWord0
                            .graph_imm_x #1
                            ;   y  ->    zpy
                            .graph_imm_y #1
                            ;  ay   ->  ay 
                            .load_imm_ay #20 ;   length

                            jsr graph.horizontal_line

                            ;   ay ->   zpWord0
                            .graph_imm_x #1
                            ;   y  ->    zpy
                            .graph_imm_y #1
                            ;  ay   ->  ay 
                            .load_imm_ay   #20
                            ;lda #20 ;   length
                            
                            jsr graph.vertical_line

                            rts
                        
                        .pend
                
                ; #################################
                
    .pend

.pend

;;;
;;
;

