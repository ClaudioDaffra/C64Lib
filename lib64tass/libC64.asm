
; C64
	
;--------------------------------------------------------------- global

zpa		= $02
zpx		= $2a
zpy		= $52

zpByte0 = $fb
zpByte1 = $fc
zpByte2 = $fd
zpByte3 = $fe

zpWord0 = $fb
zpWord1 = $fd
 

; ---------------------------------------------------------------

load_ay	.macro

	lda <\1
	ldy >\1

.endm

load_string	.macro

	lda #<\1
	ldy #>\1

.endm

load_zpByte0	.macro

	lda \1
	sta zpByte0

.endm

load_zpWord0	.macro

	lda <\1
	sta zpWord0
	lda >\1
	sta zpWord0+1
	
.endm

; ---------------------------------------------------------------

load_zpByte1	.macro

	lda \1
	sta zpByte1

.endm

load_zpWord1	.macro

	lda <\1
	sta zpWord1
	lda >\1
	sta zpWord1+1
	
.endm

; ---------------------------------------------------------------

then	.macro
	bcs \1
.endm

; ---------------------------------------------------------------

else	.macro
	bcc \1
.endm

;;;
;;
;