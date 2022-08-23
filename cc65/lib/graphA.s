
; *******
;
; grapA Lib
;
; *******


	.include "C64.inc"
	.include "graphA.inc"	

; ****************************************************	import

	.importzp	sp 
	.import 	popa, popax
	.importzp 	ptr1, ptr2

; ****************************************************	export 

	; ### public 
	
	.export _graphStartHR	,	_graphStartMC
	.export _graphEndHR		,	_graphEndMC
	.export _graphInit		,	_graphEnd
	
	.export _graphMode
	.export _graphBitMapClear
	.export _graphBitMapOn
	.export _graphBitMapOff	
	
	.export _graphScreenClear1024	
	.export _graphScreenClear

	.export _graphColor0	
	.export _graphColor1	
	.export _graphColor2	
	.export _graphColor3	

	.export _pointX
	.export _pointY
	.export _graphDrawMode
	
	.export _plotPoint
	.export _plotPointMC
	
	.export _graphSetMultiColor
	
	; ### private
	
	;	_graphScreen
	;	graphBitMapAddr

	
; **************************************************** global
;														
; ****************************************************

_graphMode:	.byte 0

; **************************************************** _graphSetBank4	,	_graphSetBank0 (default)
;
; ****************************************************	

	
; **************************************************** _graphStartHR
;
; ****************************************************	

_graphStartHR:

	lda 53265        ; set 320x200
	ora #obit6       ; 0010:0000
	sta 53265
	rts

; **************************************************** _graphEndHR
;
; ****************************************************

_graphEndHR:   

	lda 53265        ; set 320x200
	and #abit6       ; 1101:1111
	sta 53265

	rts

; **************************************************** _graphStartMC
;
; ****************************************************

_graphStartMC:

	lda 53265        ; set 160x200
	ora #obit6            
	sta 53265

	lda 53270        
	ora #obit5            
	sta 53270

	rts

; **************************************************** _graphEndMC
;
; ****************************************************

_graphEndMC:   

	lda 53265        ; set off 160x200
	and #abit6       
	sta 53265

	lda 53270         
	and #abit5        
	sta 53270

	rts

; **************************************************** _graphInit
;
; ****************************************************
	
_graphInit:   

	sta _graphMode

	bne	@gimc
	
	jmp _graphStartHR
	;rts
	
@gimc:

	jmp _graphStartMC
	;rts

; **************************************************** _graphEnd
;
; ****************************************************
	
_graphEnd:   

	lda _graphMode

	bne	@gimc
	
	jmp _graphEndHR
	;rts
	
@gimc:

	jmp _graphEndMC
	;rts
	
; **************************************************** _graphBitMapOn
;
; ****************************************************

_graphBitMapOn:

        lda 53272        ; 8192
        ora #obit4       ; 0000:1000
        sta 53272

        rts

; **************************************************** _graphBitMapOff
;
; ****************************************************

_graphBitMapOff:

        lda 53272        ; 8192
        and #abit4       ; 1111:0111
        sta 53272 

        rts
		
; **************************************************** _graphBitMapClear
;
;	1 	pixel	acceso	
;	0			spento
;
;	--	Hi res 2 color
;
;	0	col0
;	1	col1
;
;	--	lo res 4 color
;
;	00	col0
;	01	col1
;	10	col2
;	11	col3
;
; ****************************************************
	
.PROC	_graphBitMapClear

        ldx graphBitMap+1
        lda graphBitMap+0

		;	****	tay			//	ottimizzazione
		lda #00
		tay
	
        stx $ff					;	$20	(default)
        sta $fe					;	$00	

c1:     sta ($fe),y             ;	(graphBitMap) $2000 ( default ) + y
        iny
        bne c1
		
        inc $ff
        dex
        bne c1

        rts
		
.ENDPROC
	
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
		
        ldx graphScreen+1
        lda graphScreen+0

		;	****	tay			//	ottimizzazione
		lda #00
		tay

        stx $ff					;	$04	(default)
        sta $fe					;	$00

		pla
		
c1:     sta ($fe),y             ;	(graphBitMap) $0400 ( default ) + y
        iny
        bne c1
		
        inc $ff
        dex						;	lo fa per 4 volte
        bne c1

        rts
		

; ***************************************************. _graphScreenClear1024
;
; ****************************************************

.PROC _graphScreenClear1024   

        lda _graphColor1 
        asl
        asl
        asl
        asl 
        ora _graphColor0

		; start
		
_graphScreenClear1024Custom:

        ldy #$00	
		
c2a:    sta $400,y              ;       1024-2048
        iny
        bne c2a

c2b:    sta $500,y
        iny
        bne c2b

c2c:    sta $600,y
        iny
        bne c2c

        ldy #$e8

c2d:    sta $6ff,y
        dey
        bne c2d

        rts


.ENDPROC

; ***************************************************. _graphSetMultiColor
;
; ****************************************************

.PROC _graphSetColor4   

         ldy #$00                ;       $00

c2a4:    sta $d800,y            ;       1024-2048
         iny
         bne c2a4

c2b4:    sta $d900,y
         iny
         bne c2b4

c2c4:     sta $da00,y
         iny
         bne c2c4

         ldy #$e8

c2d4:    sta $db00,y
         dey
         bne c2d4

        rts
		
.ENDPROC
		
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

	rts

; ****************************************************


_plotPointMC:

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

	lda (gPointer),y                ;erase couple of bit 
	
	and tblMC_andbitbit,x     
	
	sta (gPointer),y                 

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

	sta (gPointer),y  
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

		