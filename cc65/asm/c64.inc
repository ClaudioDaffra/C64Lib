
.ifndef C64
.define	C64


; *******
;
; C64 Lib
;
; *******

; .................................................... text color

screenFrameColor 	= 	53280
backGroundColor  	= 	53281

; .................................................... and or

obit1           =       %00000001             
obit2           =       %00000010  
obit3           =       %00000100      
obit4           =       %00001000
obit5           =       %00010000      
obit6           =       %00100000  
obit7           =       %01000000      
obit8           =       %10000000  

abit1           =       %11111110      
abit2           =       %11111101  
abit3           =       %11111011      
abit4           =       %11110111
abit5           =       %11101111      
abit6           =       %11011111  
abit7           =       %10111111      
abit8           =       %01111111

; .................................................... boolean

off			=	0
on			=	1

false		=	0
true		=	1

; .................................................... Color

cBlack          =       0               ;       0000
cWhite          =       1               ;       0001
cRed            =       2               ;       0010
cCyan           =       3               ;       0011
cViolet         =       4               ;       0100
cGreen          =       5               ;       0101
cBlue           =       6               ;       0110
cYellow         =       7               ;       0111

cOrange         =       8               ;       1000
cBrown          =       9               ;       1001
cLightRed       =       10              ;       1010
cDarkGrey       =       11              ;       1011
cGrey2          =       12              ;       1100
cLightGreen     =       13              ;       1101
cLightBlue      =       14              ;       1110
cLightGrey      =       15              ;       1111



;


.endif


;
