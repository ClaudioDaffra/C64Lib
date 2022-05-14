
; .................................................... MAIN

; PROGRAM

* = $c000

; INCLUDE

Incasm "C:\c64.lib\lib.src\kernal.asm"
Incasm "C:\c64.lib\lib.src\graphic.asm"

*= $6000

; MAIN

        ;jmp startMulticolor 

;       --------------------------------- HR start graphics
      
        jsr graphStartHR

        jsr graphSetBankOn8192

        jsr graphClear

        mGraphSetColor cRed,cYellow

        ; plot unplot

        mPlotXY   #0,#3,#0,#3 
        mPlotXY   #0,#5,#0,#5  
        mPlotXY   #0,#7,#0,#7  
        mPlotXY   #0,#9,#0,#9  

        mUnPlotXY #0,#5,#0,#5  

        ; end graphics

        ;jsr graphSetBankOff8192

        ;jsr graphEndHR

        ;jsr kClearScreen 

        rts

