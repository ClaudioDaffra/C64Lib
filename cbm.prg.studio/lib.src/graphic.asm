
; ....................................................  
; 
; C64 Lib : Graphic Lib
;
;
;       Leonardo Boselli   :       support@youdev.it
;                                  https://www.youdev.it/
;
;       Claudio Daffra     :       daffra.claudio@gmail.com
;                                  http://claudiodaffra.altervista.org/
;
; ....................................................

vic  =  53248

; .................................................... color

screenFramColor = 53280
backGroundColor = 53281

; .................................................... Const Color

cBlack          =       0               ;       0000
cWhite          =       1               ;       0001
cRed            =       2               ;       0010
cCyan           =       3               ;       0011
cViolet         =       4               ;       0100
cGreen          =       5               ;       0101
cBlue           =       6               ;       0110
cYellow         =       7               ;       0111

cOrange         =       8               ;       1100
cBrown          =       9               ;       1101
cLightRed       =       10              ;       1110
cDarkGrey       =       11              ;       1111
cGrey2          =       12              ;       1100
cLightGreen     =       13              ;       1101
cLightBlue      =       14              ;       1110
cLightGrey      =       15              ;       1111

; .................................................... ADDRESS POINT

pointY          =       $fc

pointX          =       $fa
pointXhi        =       $fa 
pointXlo        =       $fb 

; .................................................... m PLOT XY
;
; plot pixel in High Resolution
;
; Input :       /1    /2      /3      /4
; lda   :       --    Y       Xhi     Xlo 
;

defm  mPlotXY

        lda /4
        sta pointY

        lda /1
        sta pointX+0

        lda /2
        sta pointX+1

        jsr graphSetPixelOn

        endm

; .................................................... m UNPLOT XY
;
; unPlot pixel in High Resolution
;
; Input :       /1    /2      /3      /4
; lda   :       --    Y       Xhi     Xlo 
;

defm  mUnPlotXY

        lda /4
        sta pointY

        lda /1
        sta pointX+0

        lda /2
        sta pointX+1

        jsr graphSetPixelOff

        endm


; .................................................... graph set bank 8192

graphSetBankOn8192

        lda 53272        ; 8192
        ora #obit4       ; 0000:1000
        sta 53272

        rts

graphSetBankOff8192

        lda 53272        ; 8192
        and #abit4       ; 1111:0111
        sta 53272 

        rts

; .................................................... graphInit HR 320x200

graphStartHR   

        lda 53265        ; set 320x200
        ora #obit6       ; 0010:0000
        sta 53265
        rts

graphEndHR   

        lda 53265        ; set 320x200
        and #abit6       ; 1101:1111
        sta 53265

        rts

; .................................................... graphInit MC 160x200

graphStartMC   

        lda 53265        ; set 160x200
        ora #obit6            
        sta 53265

        lda 53270        
        ora #obit5            
        sta 53270

        rts

graphEndMC   

        lda 53265        ; set off 160x200
        and #abit6       
        sta 53265

        lda 53270         
        and #abit5        
        sta 53270

        rts

; .................................................... graph bank 8192 clear
;
; clear graphic area
;
;
; # graphClear 
;
; input : a     x
;       : ff    fe
;       : 00    20      (8192)
;
;       : y=0 internal
;
; # graph Clear Custom usage :
;
;       lda #$20
;       ldx #$00
;       ldy #$00
;       jsr GraphClearCustom
;

graphClear   

        ldx #$20                ;       $20
        lda #$00                ;       $00
        
		tay

        stx $ff
        sta $fe

graphClearCustom

c1      sta ($fe),y             ;       $2000+y
        iny
        bne c1
        inc $ff
        dex
        bne c1

        rts

; .................................................... graph set color

graphSetColor   

        ldy #$00

c2a     sta $400,y              ;       1024-2048
        iny
        bne c2a

c2b     sta $500,y
        iny
        bne c2b

c2c     sta $600,y
        iny
        bne c2c

        ldy #$e8

c2d     sta $6ff,y
        dey
        bne c2d

        rts

; .................................................... graph set color

graphSetColor4   

         ldy #$00                ;       $00

c2a4     sta $d800,y            ;       1024-2048
         iny
         bne c2a4

c2b4     sta $d900,y
         iny
         bne c2b4

c2c4     sta $da00,y
         iny
         bne c2c4

         ldy #$e8

c2d4     sta $db00,y
         dey
         bne c2d4

        rts

; .................................................... set color

defm mGraphSetColor

        lda #/1           
        asl
        asl
        asl
        asl 
        ora #/2
        jsr graphSetColor

        endm

; .................................................... set multi color

defm mGraphSetMultiColor

        lda #/1            
        sta backGroundColor

        lda #/2           
        asl
        asl
        asl
        asl 
        ora #/3
        jsr graphSetColor

        lda #/4                
        jsr graphSetColor4

        endm

; .................................................... table power 2

power2  byte $80,$40,$20,$10,$08,$04,$02,$01

th      byte $20,$21,$22,$23
        byte $25,$26,$27,$28
        byte $2a,$2b,$2c,$2d
        byte $2f,$30,$31,$32
        byte $34,$35,$36,$37
        byte $39,$3a,$3b,$3c
        byte $3e

tl      byte $00,$40,$80,$c0
        byte $00,$40,$80,$c0
        byte $00,$40,$80,$c0
        byte $00,$40,$80,$c0
        byte $00,$40,$80,$c0
        byte $00,$40,$80,$c0
        byte $00

; .................................................... set pixel

        ;  mPlotXY
        ;
        ;  INPUT :
        ;
        ;       $fa     x.hi
        ;       $fb     x.lo
        ;       $fc     y

        ;       30000 rem set Pixel 320x200
        ;       30010 ra = 320*int(yc/8)+(yc and 7)
        ;       30020 ba = 8*int(xc/8)
        ;       30030 ma = 2^(7-(xc and 7))
        ;       30040 ad = ga + ra + ba
        ;       30050 poke ad,peek(ad) or  ma
        ;       30060 return

graphSetPixelOn 
   
        lda $fc                 ; y in $fc
        tay
        lsr a
        lsr a
        lsr a
        tax
        lda tl,x
        sta $fe                 ; low
        lda th,x
        clc
        adc $fa                 ; hx in $fa
        sta $ff                 ; high
        tya
        and #$7
        sta $fc                 ; temp
        lda $fb                 ; xl in $fb
        tax
        and #$f8
        adc $fc                 ; temp
        tay
        txa
        and #$7
        tax
        lda power2,x
        ora ($fe),y
        sta ($fe),y
        rts

; .................................................... clear pixel

        ;  mUnPlotXY
        ;
        ;  INPUT :  
        ;
        ;       $fa     x.hi
        ;       $fb     x.lo
        ;       $fc     y

        ;       31000 rem clr Pixel 320x200
        ;       31010 ra = 320*int(yc/8)+(yc and 7)
        ;       31020 ba = 8*int(xc/8)
        ;       31030 ma = 255-2^(7-(xc and 7))
        ;       31040 ad = ga + ra + ba
        ;       31050 peek(ad) and  ma,peek(ad) and  ma
        ;       31060 return

graphSetPixelOff 
   
        lda $fc                 ; y in $fc
        tay
        lsr a                   ; y/8
        lsr a
        lsr a
        tax
        lda tl,x
        sta $fe                 ; low
        lda th,x
        clc
        adc $fa                 ; hx in $fa
        sta $ff                 ; high
        tya
        and #$7
        sta $fc                 ; temp
        lda $fb                 ; xl in $fb
        tax
        and #$f8                ; %11111000
        adc $fc                 ; temp
        tay
        txa
        and #$7                 ; (xc and 7)
        tax

        lda power2,x    ;       2^(7-(xc and 7))

        eor #$ff        ;       255 -

        and ($fe),y     ;       peek(ad) and  ma

        sta ($fe),y     ;       peek(ad) and  ma

        rts


;
;
;
