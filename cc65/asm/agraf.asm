
; *******
;
; lgraf Lib
;
; *******

.include "c64.inc"

.ifndef GRAPHADDR
.define	GRAPHADDR  $E000
.endif

.ifndef SCREENADDR
.define	SCREENADDR $CC00
.endif

; *******

;	bitmap		$e000
;	screen char	$cc00
;	
;	$c000	3072 byte free

; *******

.export _graphHiresColor
.export _graphMultiColor
.export _graphTextMode
.export _graphBitmapClear
.export _graphIntRomDisable
.export _graphIntRomEnable

.export _graphBitMap
.export _graphScreenChar

.export _graphColor0	
.export _graphColor1	
.export _graphColor2	
.export _graphColor3	

.export _graphScreenClear
.export _graphBitmapClearFast

.export _graphSetMultiColor
.export _graphOff

.export _graphDrawMode
.export _graphMode
 
.export _graphInit

.export _pointX
.export _pointY

.export _plotPoint
.export _plotPointMC

.export _graphSetColor4
	
; .................................................... define

graphBitMapAddr		= 	GRAPHADDR

_graphScreenColor	=	$d800

graphMode320x200	=	0
graphMode160x200	=	1

; .................................................... global

_graphBitMap:		.word GRAPHADDR
_graphScreenChar:	.word SCREENADDR

; .................................................... graph mode hires or multiColor

_graphMode:	.byte 0

; .................................................... grap draw mode
;
;	HR	:	0 = off, 1 = on
;	MC	:	col(0)	col(1)	col(2)	col(3)

_graphDrawMode: .byte 1

; .................................................... graph pointer

gPointer = $fb	;	fb:fc

; .................................................... color

_graphColor0:	.byte	0
_graphColor1:	.byte	1
_graphColor2:	.byte	2
_graphColor3:	.byte	3

; .................................................... plot XY

_pointX: 	.word 0		;	0-319
_pointY:	.byte 0		;	0-199

; **************************************************** _graphHiresColor
;
; ****************************************************

_graphHiresColor:

		;	multi color off 	

					;	7654:3210	(53270)
		lda	#$ef	;	1110:1111
		and $d016	;	resetta bit multi color		
		sta $d016	;	Bit #4: 0 = Multicolor mode off . 1 = Multicolor mode on.

		jsr _grafON
		
		rts
		
		;	graf on 
		
_grafON:				
					;	7654:3210	(53265)
		lda	#$20	;	0010:0000
		ora $d011	;	Bit #5: 0 = Text mode; 1 = Bitmap mode
		sta $d011
		
		;	pointer to bitmap, screen		
				
					;	7654:3210	(53272)		
		lda #$38	;	0011:1000
		sta	$d018	;	%100u,  4: $2000-$3FFF, 8192-16383.	pointer to bitmap memory
					;	%0011,  3: $0C00-$0FFF, 3072-4095.	Pointer to screen memory
		
		;	bank 4		
		
					;	7654:3210	(56576)	
		lda #$fc	;	1111:1100
		and $dd00	;		  %00, 0: Bank #3, $C000-$FFFF, 49152-65535.
		sta $dd00	;	
		
		rts

; **************************************************** _graphTextMode
;
; ****************************************************

_graphTextMode:

		;	graf off 	

					;	7654:3210	(53265)
		lda #$df	;	1101:1111
		and $d011	;	abilita modo testo
		sta $d011	;	Bit #5: 0 = Text mode; 1 = Bitmap mode
		
		;	pointer to bitmap,screen		
				
					;	7654:3210	(53272)		
		lda #$15	;	0001:0101
		sta	$d018	;	%1xxu,  4: $2000-$3FFF,  8192-16383.	pointer to bitmap memory
					;	%0001,  1: $0400-$07FF,  1024-2047.		Pointer to screen memory
		
		;	bank 1		
		
		lda #$03	;	0000:0011
		ora $dd00	;		  %11, 3: Bank #0, $0000-$3FFF, 0-16383.
		sta	$dd00	;	
		
		lda $d011	; set off 160x200
		and #abit6       
		sta 53265

		lda $d016         
		and #abit5        
		sta 53270
	
		rts

; **************************************************** _graphMultiColor
;
; ****************************************************

_graphMultiColor:

					;	7654:3210	(53270)
		lda	#$10	;	0001:0000
		ora $d016	;	setta bit multi color		
		sta $d016	;	Bit #4: 0 = Multicolor mode off . 1 = Multicolor mode on.

		jmp _grafON
		
		rts

; ***************************************************. _graphSetMultiColor
;
; ****************************************************

.PROC _graphSetColor4   

         jsr _graphIntRomDisable
   
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

        jsr _graphIntRomEnable

        rts
		
.ENDPROC

; **************************************************** _graphSetMultiColor
;
; ****************************************************

.PROC _graphSetMultiColor

		; #0
		lda _graphColor0
		sta backGroundColor

		; #1 #2
        lda _graphColor1           
        asl
        asl
        asl
        asl 
        ora _graphColor2

		jsr _graphScreenClearCustom
		
		; #3
		
		lda _graphColor3
		jsr _graphSetColor4

		rts
		
.ENDPROC

; **************************************************** _graphBitmapClear
;
; ****************************************************

_graphBitmapClear:

		;	$00F9-$00FA		; 	Pointer to RS232 output buffer. Values:
		;	$00FB-$00FE		;	unused

		lda	_graphBitMap+1	;	E0	load pointer bitmap $e000	( bank4 $c000 + $2000 ) 
		sta	$fa
		
		lda	_graphBitMap+0 	;	00
		sta	$f9
		
		ldx #$20
		tay
		
_gclear_loop:			;	clear bitmap	*($f9/$fa) = 0	[00e0]
		
		sta ($f9),y
		iny
		bne	_gclear_loop
		inc $fa
		dex
		bne	_gclear_loop
		
		rts

_graphBitmapClearFast:

		lda #$00
		tax

_gBitmapClearFastLoop:

		sta GRAPHADDR+256*0 , x
		sta GRAPHADDR+256*1 , x			
		sta GRAPHADDR+256*2 , x
		sta GRAPHADDR+256*3 , x	
		sta GRAPHADDR+256*4 , x
		sta GRAPHADDR+256*5 , x			
		sta GRAPHADDR+256*6 , x
		sta GRAPHADDR+256*7 , x	
		sta GRAPHADDR+256*8 , x
		sta GRAPHADDR+256*9 , x			
		sta GRAPHADDR+256*10, x
		sta GRAPHADDR+256*11, x	
		sta GRAPHADDR+256*12, x
		sta GRAPHADDR+256*13, x			
		sta GRAPHADDR+256*14, x
		sta GRAPHADDR+256*15, x	
		
		sta GRAPHADDR+256*16, x
		sta GRAPHADDR+256*17, x			
		sta GRAPHADDR+256*18, x
		sta GRAPHADDR+256*19, x	
		sta GRAPHADDR+256*20, x
		sta GRAPHADDR+256*21, x			
		sta GRAPHADDR+256*22, x
		sta GRAPHADDR+256*23, x	
		sta GRAPHADDR+256*24, x
		sta GRAPHADDR+256*25, x			
		sta GRAPHADDR+256*26, x
		sta GRAPHADDR+256*27, x	
		sta GRAPHADDR+256*28, x
		sta GRAPHADDR+256*29, x			
		sta GRAPHADDR+256*30, x
		sta GRAPHADDR+256*31, x	

		inx 
		bne	_gBitmapClearFastLoop

		ldx #64
		lda #$00

_gBitmapClearFastLoop2:

	    sta GRAPHADDR+256*31+64
		dex
		bne	_gBitmapClearFastLoop2
		
		rts
		
; **************************************************** _graphIntRomDisable
;
; ****************************************************

_graphIntRomDisable:

	lda $a0
	sta	$fd
	lda $a1
	sta	$fe
	lda $a2
	sta	$ff
	
	lda	#$fe		;	1111:11[10]
	and	$dc0e		;	 
	sta	$dc0e
	
	lda	#$fd		;	 1111:11[01]	%x01: RAM visible at $A000-$BFFF and $E000-$FFFF.
	and	$01
	sta $01
	
	rts

; **************************************************** _graphIntRomEnable
;
; ****************************************************
	
_graphIntRomEnable:

	lda	#$02		;	0000:00[10] %x10:  RAM visible at $A000-$BFFF; 
	ora	$01			;				KERNAL ROM visible at $E000-$FFFF.
	sta $01
	
	lda	#$01		;	0000:0001
	ora	$dc0e
	sta	$dc0e
	
	lda	$ff
	sta $a2
	lda	$fd
	sta $a1
	lda	$fe
	sta $a0

	rts

; **************************************************** _graphScreenClear
;
; ****************************************************

_graphScreenClear:

        lda _graphColor1 		;	calcola colori hi lo
        asl
        asl
        asl
        asl 
        ora _graphColor0

_graphScreenClearCustom:

		pha
		
        ldx _graphScreenChar+1
        lda _graphScreenChar+0

		;	****	tay			//	ottimizzazione
		lda #00
		tay

        stx $ff					;	$04	(default)
        sta $fe					;	$00

		pla
		
		ldx #$04				;	4*256 1024
		
_graphScreenClearLoop:     

		sta ($fe),y             ;
        iny
        bne _graphScreenClearLoop
		
        inc $ff
        dex						;	4 times
		
        bne _graphScreenClearLoop

        rts
		
; **************************************************** _graphOff
;
; ****************************************************

_graphOff:

	lda #200
	sta $d016
	
	lda #27
	sta $d011
	
	lda #21
	sta $d018
	
	lda #151
	sta $dd00
 
	rts
	
; **************************************************** _graphInit
;
; ****************************************************
	
_graphInit:   

	sta _graphMode

	bne	@gimc
	
	jmp _graphHiresColor
	;rts
	
@gimc:

	jmp _graphMultiColor
	;rts
	
; ****************************************************
; ****************************************************	SET ERASE PIXEL
; ****************************************************

;This routine sets or erases a point on the hires _graphBitMap based
;on coordinates and _graphDrawMode determined before-hand.  you can change
;"_graphBitMap" to wherever your hires _graphBitMap is located.
;plotPoint works by first determining which 8x8 cell the point is
;located in and uses tables to figure that out.
;The in-cell offset is determined by just isolating the lowest 3 bits
;of each point (0-7).  The pixel masking uses tables, too.

_plotPoint:

	;calc Y-cell, divide by 8	y/8 is y-cell table index

	lda _pointY
	lsr                         ;/ 2
	lsr                         ;/ 4
	lsr                         ;/ 8
	tay                         ;tbl_8,y index

	;............................calc X-cell, divide by 8 divide 2-byte _pointX / 8

	ror _pointX+1                ;rotate the high byte into carry flag
	lda _pointX
	ror                         ;lo byte / 2 (rotate C into low byte)
	lsr                         ;lo byte / 4
	lsr                         ;lo byte / 8
	tax                         ;tbl_8,x index

	;............................add x & y to calc cell point is in

	clc

	lda tbl_vbaseLo,y           ;table of _graphBitMap row base addresses
	adc tbl_8Lo,x               ;+ (8 * Xcell)
	sta gPointer                ;= cell address

	lda tbl_vbaseHi,y           ;do the high byte
	adc tbl_8Hi,x
	sta gPointer+1

	;...........................get in-cell offset to point (0-7)

	lda _pointX                 ;get _pointX offset from cell topleft
	and #%00000111              ;3 lowest bits = (0-7)
	tax                         ;put into index register

	lda _pointY                 ;get _pointY offset from cell topleft
	and #%00000111              ;3 lowest bits = (0-7)
	tay                         ;put into index register

	;----------------------------------------------
	;depending on _graphDrawMode, routine draws or erases
	;----------------------------------------------

	lda _graphDrawMode       	;(0 = erase, 1 = set)
	beq erase                   ;if = 0 then branch to clear the point

	;---------
	;set point
	;---------

	jsr _graphIntRomDisable
	
	lda (gPointer),y            ;get row with point in it
	ora tbl_orbit,x             ;isolate and set the point
	sta (gPointer),y            ;write back to _graphBitMap

	jmp past                    ;skip the erase-point section

	;-----------
	;erase point
	;-----------

	erase:                    ;handled same way as setting a point

	lda (gPointer),y          ;just with opposite bit-mask
	and tbl_andbit,x          ;isolate and erase the point
	sta (gPointer),y          ;write back to _graphBitMap

	past:
	jsr _graphIntRomEnable
	
	rts

; ****************************************************


_plotPointMC:

    jsr _graphIntRomDisable

	;...........................calc Y-cell, divide by 8	y/8 is y-cell table index

	lda _pointY
	lsr                         ;/ 2
	lsr                         ;/ 4
	lsr                         ;/ 8
	tay                         ;tbl_8,y index

	;............................calc X-cell, divide by 8 divide 2-byte _pointX / 8

	ror _pointX+1                ;rotate the high byte into carry flag
	lda _pointX
	ror                         ;lo byte / 2 (rotate C into low byte)
	lsr                         ;lo byte / 4
	lsr                         ;lo byte / 8
	tax                         ;tbl_8,x index

	;............................add x & y to calc cell point is in

	clc

	lda tbl_vbaseLo,y           ;table of _graphBitMap row base addresses
	adc tbl_8Lo,x               ;+ (8 * Xcell)
	sta gPointer                ;= cell address

	lda tbl_vbaseHi,y           ;do the high byte
	adc tbl_8Hi,x
	sta gPointer+1

	;...........................get in-cell offset to point (0-7)

	lda _pointX                 ;get _pointX offset from cell topleft
	and #%00000111              ;3 lowest bits = (0-7)
	tax                         ;put into index register

	lda _pointY                 ;get _pointY offset from cell topleft
	and #%00000111              ;3 lowest bits = (0-7)
	tay                         ;put into index register

	;----------------------------------------------
	;# erase bit xx00000000
	;----------------------------------------------

	;jsr _graphIntRomDisable	
	
	lda (gPointer),y   			;erase couple of bit 
	
	and tblMC_andbitbit,x  

	sta (gPointer),y                 

	;jsr _graphIntRomEnable
	
	pha 						; salva risultato

	lda _graphDrawMode       	; get color
	
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
	
	sta (gPointer),y 

	jsr _graphIntRomEnable
	
	rts

; ****************************************************
; ****************************************************	TABELLE
; ****************************************************

tbl_vbaseLo =*
.lobytes	graphBitMapAddr+(0*320)	,graphBitMapAddr+(1*320)	,graphBitMapAddr+(2*320)	,graphBitMapAddr+(3*320)
.lobytes	graphBitMapAddr+(4*320)	,graphBitMapAddr+(5*320)	,graphBitMapAddr+(6*320)	,graphBitMapAddr+(7*320)
.lobytes	graphBitMapAddr+(8*320)	,graphBitMapAddr+(9*320)	,graphBitMapAddr+(10*320)	,graphBitMapAddr+(11*320)
.lobytes	graphBitMapAddr+(12*320),graphBitMapAddr+(13*320)	,graphBitMapAddr+(14*320)	,graphBitMapAddr+(15*320)
.lobytes	graphBitMapAddr+(16*320),graphBitMapAddr+(17*320)	,graphBitMapAddr+(18*320)	,graphBitMapAddr+(19*320)
.lobytes	graphBitMapAddr+(20*320),graphBitMapAddr+(21*320)	,graphBitMapAddr+(22*320)	,graphBitMapAddr+(23*320)
.lobytes	graphBitMapAddr+(24*320)

tbl_vbaseHi =*
.hibytes	graphBitMapAddr+(0*320)	,graphBitMapAddr+(1*320)	,graphBitMapAddr+(2*320)	,graphBitMapAddr+(3*320)
.hibytes	graphBitMapAddr+(4*320)	,graphBitMapAddr+(5*320)	,graphBitMapAddr+(6*320)	,graphBitMapAddr+(7*320)
.hibytes	graphBitMapAddr+(8*320)	,graphBitMapAddr+(9*320)	,graphBitMapAddr+(10*320)	,graphBitMapAddr+(11*320)
.hibytes	graphBitMapAddr+(12*320),graphBitMapAddr+(13*320)	,graphBitMapAddr+(14*320)	,graphBitMapAddr+(15*320)
.hibytes	graphBitMapAddr+(16*320),graphBitMapAddr+(17*320)	,graphBitMapAddr+(18*320)	,graphBitMapAddr+(19*320)
.hibytes	graphBitMapAddr+(20*320),graphBitMapAddr+(21*320)	,graphBitMapAddr+(22*320)	,graphBitMapAddr+(23*320)
.hibytes	graphBitMapAddr+(24*320)

tbl_8Lo =*
.lobytes	 0*8	, 1*8	, 2*8	, 3*8	, 4*8	, 5*8	, 6*8	, 7*8	, 8*8	, 9*8
.lobytes	10*8	,11*8	,12*8	,13*8	,14*8	,15*8	,16*8	,17*8	,18*8	,19*8
.lobytes	20*8	,21*8	,22*8	,23*8	,24*8	,25*8	,26*8	,27*8	,28*8	,29*8
.lobytes	30*8	,31*8	,32*8	,33*8	,34*8	,35*8	,36*8	,37*8	,38*8	,39*8

tbl_8Hi =*
.hibytes	0*8		, 1*8	, 2*8	, 3*8	, 4*8	, 5*8	, 6*8	, 7*8	, 8*8	, 9*8
.hibytes	10*8	,11*8	,12*8	,13*8	,14*8	,15*8	,16*8	,17*8	,18*8	,19*8
.hibytes	20*8	,21*8	,22*8	,23*8	,24*8	,25*8	,26*8	,27*8	,28*8	,29*8
.hibytes	30*8	,31*8	,32*8	,33*8	,34*8	,35*8	,36*8	,37*8	,38*8	,39*8

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

;--------------------------------------------------------- tabelle lo res

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
