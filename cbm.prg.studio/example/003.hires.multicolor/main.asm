
; .................................................... MAIN

; PROGRAM

* = $c000

; INCLUDE

Incasm "C:\c64.lib\lib.src\kernal.asm"
Incasm "C:\c64.lib\lib.src\graphic.asm"
Incasm "C:\c64.lib\lib.src\math.asm"

;       --------------------------------- sub Plot Multi Color XY

plotMCXY

        pha ; +a
        tya
        pha ; +y
        
        lda #0
        sta num16_1hi
        stx num16_1lo;
        sta num16_2hi
        stx num16_2lo;
        
        jsr add16

        lda res16_hi
        sta pointXhi
        lda res16_lo
        sta pointXlo
        pla ; -y
        sta pointY

        pla ;-a

        cmp #0
        beq plotMCXY_0
        cmp #1
        beq plotMCXY_1
        cmp #2
        beq plotMCXY_2
        cmp #3
        beq plotMCXY_3

        rts
 
        
plotMCXY_0
        jsr graphSetPixelOff
        inc pointXlo
        jsr graphSetPixelOff
        rts

plotMCXY_1
        jsr graphSetPixelOff
        inc pointXlo
        jsr graphSetPixelOn
        rts

plotMCXY_2
        jsr graphSetPixelOn
        inc pointXlo
        jsr graphSetPixelOff
        rts

plotMCXY_3
        jsr graphSetPixelOn
        inc pointXlo
        jsr graphSetPixelOn
        rts


;       --------------------------------- m Plot Multi Color XY

defm mPlotMCXY 


        lda /1
        ldx /2
        ldy /3
        jsr plotMCXY 

        endm



*= $6000



; MAIN


;       --------------------------------- HR start graphics
      
        jsr graphStartMC

        jsr graphSetBankOn8192

        jsr graphClear

        mGraphSetMultiColor cRed,cYellow,cCyan,cWhite


        mPlotMCXY #1,#1,#1
        mPlotMCXY #0,#3,#3
        mPlotMCXY #2,#5,#5
        mPlotMCXY #3,#7,#7
      
        ;lda #3
        ;ldx #7
        ;ldy #7
        ;jsr mPlotMCXY 


        ;jsr graphSetBankOff8192

        ;jsr graphEndMC

        ;jsr kClearScreen 

        rts


