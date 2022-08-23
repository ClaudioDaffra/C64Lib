
.ifndef GRAPHIC
.define	GRAPHIC


.ifndef GRAPHADDR
.define	GRAPHADDR	$2000
.endif

; *******
;
; graphic
;
; *******

; .................................................... Graphic ## .DEFINE

vic  				=   53248
graphBitMapAddr		= 	GRAPHADDR


graphMode320x200	=	0
graphMode160x200	=	1

screenFrameColor 	= 	53280
backGroundColor  	= 	53281

; .................................................... Graphic ## GLOBAL

graphColor			=		$d800		;	can not be change
graphScreen:		.word	1024
graphBitMap:		.word 	GRAPHADDR

; .................................................... color

_graphColor0:	.byte	0
_graphColor1:	.byte	1
_graphColor2:	.byte	2
_graphColor3:	.byte	3

; .................................................... plot XY

_pointX: 	.word 0		;	0-319
_pointY:	.byte 0		;	0-199

; .................................................... grap draw mode
;
;	HR	:	0 = off, 1 = on
;	MC	:	col(0)	col(1)	col(2)	col(3)

_graphDrawMode: .byte 1

; .................................................... graph pointer

gPointer = $fb	;	fb : fc


;

.endif




