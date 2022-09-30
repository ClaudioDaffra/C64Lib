; ****************************************************
; ****************************************************	SET ERASE PIXEL
; ****************************************************

;   zpa zpx Y
;   
;
;
;

;This routine sets or erases a point on the hires _graphBitMap based
;on coordinates and _graphDrawMode determined before-hand.  you can change
;"_graphBitMap" to wherever your hires _graphBitMap is located.
;plotPoint works by first determining which 8x8 cell the point is
;located in and uses tables to figure that out.
;The in-cell offset is determined by just isolating the lowest 3 bits
;of each point (0-7).  The pixel masking uses tables, too.

pixel   

                                Y   = zpy
                                X   =   zpWord0
                                
                                ;calc Y-cell, divide by 8	y/8 is y-cell table index

                                lda Y
                                lsr                         ;/ 2
                                lsr                         ;/ 4
                                lsr                         ;/ 8
                                tay                         ;tbl_8,y index  (Y)
                                

                                ;............................calc X-cell, divide by 8 divide 2-byte X / 8

                                ror X+1               ;rotate the high byte into carry flag
                                lda X
                                ror                         ;lo byte / 2 (rotate C into low byte)
                                lsr                         ;lo byte / 4
                                lsr                         ;lo byte / 8
                                tax                         ;tbl_8,x index  (X)

                                ;............................add x & y to calc cell point is in

                                clc

                                lda tbl_vbaseLo,y           ;table of _graphBitMap row base addresses
                                adc tbl_8Lo,x               ;+ (8 * Xcell)
                                sta pointer                ;= cell address

                                lda tbl_vbaseHi,y           ;do the high byte
                                adc tbl_8Hi,x
                                sta pointer+1

                                ;...........................get in-cell offset to point (0-7)

                                lda X                 ;get X offset from cell topleft
                                and #%00000111              ;3 lowest bits = (0-7)
                                tax                         ;put into index register

                                lda Y                 ;get Y offset from cell topleft
                                and #%00000111              ;3 lowest bits = (0-7)
                                tay                         ;put into index register

                                ;----------------------------------------------
                                ;depending on _graphDrawMode, routine draws or erases
                                ;----------------------------------------------

                                ; TODO  screen.color_number zpa
                                
                                lda _graphDrawMode       	;(0 = erase, 1 = set)
                                beq erase                   ;if = 0 then branch to clear the point

                                ;---------
                                ;set point
                                ;---------

                                .if c64.bitmap_addr == $E000
                                ;jsr _graphIntRomDisable
                                .endif
                                
                                lda (pointer),y            ;get row with point in it
                                ora tbl_orbit,x             ;isolate and set the point
                                sta (pointer),y            ;write back to _graphBitMap

                                jmp past                    ;skip the erase-point section

                                ;-----------
                                ;erase point
                                ;-----------

                                erase:                    ;handled same way as setting a point

                                lda (pointer),y          ;just with opposite bit-mask
                                and tbl_andbit,x          ;isolate and erase the point
                                sta (pointer),y          ;write back to _graphBitMap

                                past:
                                
                                .if c64.bitmap_addr == $E000
                                ;jsr _graphIntRomEnable
                                .endif
                                
                                rts

; ****************************************************


_plotPointMC:

    .if c64.bitmap_addr == $E000
	;jsr _graphIntRomDisable
    .endif

	;...........................calc Y-cell, divide by 8	y/8 is y-cell table index

	lda Y
	lsr                         ;/ 2
	lsr                         ;/ 4
	lsr                         ;/ 8
	tay                         ;tbl_8,y index

	;............................calc X-cell, divide by 8 divide 2-byte X / 8

	ror X+1                ;rotate the high byte into carry flag
	lda X
	ror                         ;lo byte / 2 (rotate C into low byte)
	lsr                         ;lo byte / 4
	lsr                         ;lo byte / 8
	tax                         ;tbl_8,x index

	;............................add x & y to calc cell point is in

	clc

	lda tbl_vbaseLo,y           ;table of _graphBitMap row base addresses
	adc tbl_8Lo,x               ;+ (8 * Xcell)
	sta pointer                ;= cell address

	lda tbl_vbaseHi,y           ;do the high byte
	adc tbl_8Hi,x
	sta pointer+1

	;...........................get in-cell offset to point (0-7)

	lda X                 ;get X offset from cell topleft
	and #%00000111              ;3 lowest bits = (0-7)
	tax                         ;put into index register

	lda Y                     ;get Y offset from cell topleft
	and #%00000111              ;3 lowest bits = (0-7)
	tay                         ;put into index register

	;----------------------------------------------
	;# erase bit xx00000000
	;----------------------------------------------

    .if c64.bitmap_addr == $E000
	;jsr _graphIntRomDisable
    .endif
	
	lda (pointer),y             ;erase couple of bit 
	
	and tblMC_andbitbit,x  

	sta (pointer),y                 

    .if c64.bitmap_addr == $E000
	;jsr _graphIntRomEnable
    .endif
    
	pha                         ; salva risultato

	lda _graphDrawMode          ; get color
	
	cmp #0
	beq _plotPointMC_00
	cmp #1
	beq _plotPointMC_01
	cmp #2
	beq _plotPointMC_10
	cmp #3
	beq _plotPointMC_11	
	
	pla

    jsr _graphIntRomEnable
    
	rts

_plotPointMC_00:

	pla 
	ora tblMC_orbitbit00,x 
	jmp _plotPointMC_end
	
_plotPointMC_01:

	pla 
	ora tblMC_orbitbit01,x 
	jmp _plotPointMC_end
	
_plotPointMC_10:

	pla 
	ora tblMC_orbitbit10,x 
	jmp _plotPointMC_end
	
_plotPointMC_11:

	pla 
	ora tblMC_orbitbit11,x 

_plotPointMC_end:

	;jsr _graphIntRomDisable
	
	sta (pointer),y 

	jsr _graphIntRomEnable
	
	rts

;******
;       TABELLE X,Y
;******

;
;  vBaseY :=    c64.bitmap_addr + range(0,24,1) * 320
;  
;  tbl_vbaseLo  .byte   <vBaseY 
;  tbl_vbaseHi  .byte   >vBaseY
;
; p.s. we can do much better with range 1,200 for (y) and precalculated all 320 variation (x)
;      but we need 200+200 bytes memory additional, therefore i choose 3 lsr, to calculate right address
 
tbl_vbaseLo =*

<c64.bitmap_addr+(0*320)    ,<c64.bitmap_addr+(1*320)   ,<c64.bitmap_addr+(2*320)   ,<c64.bitmap_addr+(3*320)
<c64.bitmap_addr+(4*320)    ,<c64.bitmap_addr+(5*320)   ,<c64.bitmap_addr+(6*320)   ,<c64.bitmap_addr+(7*320)
<c64.bitmap_addr+(8*320)    ,<c64.bitmap_addr+(9*320)   ,<c64.bitmap_addr+(10*320)  ,<c64.bitmap_addr+(11*320)
<c64.bitmap_addr+(12*320)   ,<c64.bitmap_addr+(13*320)  ,<c64.bitmap_addr+(14*320)  ,<c64.bitmap_addr+(15*320)
<c64.bitmap_addr+(16*320)   ,<c64.bitmap_addr+(17*320)  ,<c64.bitmap_addr+(18*320)  ,<c64.bitmap_addr+(19*320)
<c64.bitmap_addr+(20*320)   ,<c64.bitmap_addr+(21*320)  ,<c64.bitmap_addr+(22*320)  ,<c64.bitmap_addr+(23*320)
<c64.bitmap_addr+(24*320)

tbl_vbaseHi =*

>c64.bitmap_addr+(0*320)    ,>c64.bitmap_addr+(1*320)   ,>c64.bitmap_addr+(2*320)   ,>c64.bitmap_addr+(3*320)
>c64.bitmap_addr+(4*320)    ,>c64.bitmap_addr+(5*320)   ,>c64.bitmap_addr+(6*320)   ,>c64.bitmap_addr+(7*320)
>c64.bitmap_addr+(8*320)    ,>c64.bitmap_addr+(9*320)   ,>c64.bitmap_addr+(10*320)  ,>c64.bitmap_addr+(11*320)
>c64.bitmap_addr+(12*320)   ,>c64.bitmap_addr+(13*320)  ,>c64.bitmap_addr+(14*320)  ,>c64.bitmap_addr+(15*320)
>c64.bitmap_addr+(16*320)   ,>c64.bitmap_addr+(17*320)  ,>c64.bitmap_addr+(18*320)  ,>c64.bitmap_addr+(19*320)
>c64.bitmap_addr+(20*320)   ,>c64.bitmap_addr+(21*320)  ,>c64.bitmap_addr+(22*320)  ,>c64.bitmap_addr+(23*320)
>c64.bitmap_addr+(24*320)

tbl_8Lo =*

< 0*8   ,< 1*8  ,< 2*8  ,< 3*8  ,< 4*8  ,< 5*8  ,< 6*8  ,< 7*8  ,< 8*8  ,< 9*8
<10*8   ,<11*8  ,<12*8  ,<13*8  ,<14*8  ,<15*8  ,<16*8  ,<17*8  ,<18*8  ,<19*8
<20*8   ,<21*8  ,<22*8  ,<23*8  ,<24*8  ,<25*8  ,<26*8  ,<27*8  ,<28*8  ,<29*8
<30*8   ,<31*8  ,<32*8  ,<33*8  ,<34*8  ,<35*8  ,<36*8  ,<37*8  ,<38*8  ,<39*8

tbl_8Hi =*

> 0*8   ,> 1*8  ,> 2*8  ,> 3*8  ,> 4*8  ,> 5*8  ,> 6*8  ,> 7*8  ,> 8*8  ,> 9*8
>10*8   ,>11*8  ,>12*8  ,>13*8  ,>14*8  ,>15*8  ,>16*8  ,>17*8  ,>18*8  ,>19*8
>20*8   ,>21*8  ,>22*8  ,>23*8  ,>24*8  ,>25*8  ,>26*8  ,>27*8  ,>28*8  ,>29*8
>30*8   ,>31*8  ,>32*8  ,>33*8  ,>34*8  ,>35*8  ,>36*8  ,>37*8  ,>38*8  ,>39*8

                                            ;******
                                            ;       TABELLE HI RES
                                            ;******

                                            tbl_orbit =*

                                            .byte %10000000
                                            .byte %01000000
                                            .byte %00100000
                                            .byte %00010000
                                            .byte %00001000
                                            .byte %00000100
                                            .byte %00000010
                                            .byte %00000001

                                            tbl_andbit =*

                                            .byte %01111111
                                            .byte %10111111
                                            .byte %11011111
                                            .byte %11101111
                                            .byte %11110111
                                            .byte %11111011
                                            .byte %11111101
                                            .byte %11111110

                                            ;******
                                            ;       TABELLE LO RES
                                            ;******

                                            ; ................................. AND Mc azzera coppia di bit

                                            tblMC_andbitbit =*

                                            .byte %00111111
                                            .byte %00111111
                                            .byte %11001111
                                            .byte %11001111
                                            .byte %11110011
                                            .byte %11110011
                                            .byte %11111100
                                            .byte %11111100

                                            ; ................................. AND Mc accende coppia di bit

                                            tblMC_orbitbit =*

                                            ; ................................. col 0 00

                                            tblMC_orbitbit00 =*

                                            .byte %00000000
                                            .byte %00000000
                                            .byte %00000000
                                            .byte %00000000
                                            .byte %00000000
                                            .byte %00000000
                                            .byte %00000000
                                            .byte %00000000

                                            ; ................................. col 1 01

                                            tblMC_orbitbit01 =*

                                            .byte %01000000
                                            .byte %01000000
                                            .byte %00010000
                                            .byte %00010000
                                            .byte %00000100
                                            .byte %00000100
                                            .byte %00000001
                                            .byte %00000001

                                            ; ................................. col 2 10

                                            tblMC_orbitbit10 =*

                                            .byte %10000000
                                            .byte %10000000
                                            .byte %00100000
                                            .byte %00100000
                                            .byte %00001000
                                            .byte %00001000
                                            .byte %00000010
                                            .byte %00000010

                                            ; ................................. col 3 11

                                            tblMC_orbitbit11 =*

                                            .byte %11000000
                                            .byte %11000000
                                            .byte %00110000
                                            .byte %00110000
                                            .byte %00001100
                                            .byte %00001100
                                            .byte %00000011
                                            .byte %00000011


;;;
;;
;

;;;
;;
;