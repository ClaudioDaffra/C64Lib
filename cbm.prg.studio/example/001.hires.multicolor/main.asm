
; .................................................... MAIN

; PROGRAM

* = $c000

; INCLUDE

Incasm "C:\c64.lib\lib.src\kernal.asm"
Incasm "C:\c64.lib\lib.src\graphic.asm"

*= $6000

; MAIN


;       --------------------------------- HR start graphics
      
        jsr graphStartMC

        jsr graphSetBankOn8192

        jsr graphClear

        mGraphSetMultiColor cRed,cYellow,cCyan,cWhite

        ; plot unplot

        ;              
        mPlotXY         #0,#0,#0,#1 
        mPlotXY         #0,#1,#0,#1 

        mPlotXY         #0,#0,#0,#3 
        mUnPlotXY       #0,#1,#0,#3 
 

        mUnPlotXY       #0,#0,#0,#5 
        mUnPlotXY       #0,#1,#0,#5 

        mUnPlotXY       #0,#0,#0,#7 
        mPlotXY         #0,#1,#0,#7 

        ;jsr graphSetBankOff8192

        ;jsr graphEndMC

        ;jsr kClearScreen 

        rts


