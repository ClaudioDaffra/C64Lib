

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

        graphSetColor4   .proc

                 ldy #$00                ;       $00

        c2a4:    sta $d800,y            ;       1024-2048
                 iny
                 bne c2a4

        c2b4:    sta $d8ff,y
                 iny
                 bne c2b4

        c2c4:    sta $d9fe,y
                 iny
                 bne c2c4

                 ;ldy #$e8

        c2d4:    sta $daf9,y
                 ;dey
                 iny
                 bne c2d4

                rts
                
        .pend

        graphSetMultiColor .proc

            ; #0
            lda screen.background_color_0
            sta $d021

            ; #1 #2
            lda  screen.background_color_1
            asl
            asl
            asl
            asl 
            ora  screen.background_color_2

            jsr txt.clear_screen_chars
            
            ; #3
            
            lda screen.background_color_3
            jsr graphSetColor4

            rts
    .pend
        
    start	.proc


        jsr graph.lores_on

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
        
        jsr graphSetMultiColor

        ;   
        jsr graph.clear

        ;
        
        lda #254    ;   00100111
        sta 8192

        lda #129    ;   00100111
        sta 8193

        lda #67    ;   00100111
        sta 8194

        lda #47   ;   00100111
        sta 8195

        lda #17    ;   00100111
        sta 8196

        lda #13    ;   00100111
        sta 8197

        lda #5    ;   00100111
        sta 8198

        lda #3    ;   00100111
        sta 8199
        
        lda #1    ;   00100111
        sta 8200
        
rts

        jsr graph.lores_off
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

