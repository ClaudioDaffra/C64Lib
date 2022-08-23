
; math


; ---------------------------------------------------------------

math_s16_cmp_eq
math_u16_cmp_eq

	ldy  zpWord0+1
	lda  zpWord0
	cmp  zpWord1
	bne  math_s16_cmp_eq_else
	cpy  zpWord1+1
	bne  math_s16_cmp_eq_else
	sec
	rts
math_s16_cmp_eq_else
	clc
	rts

; ---------------------------------------------------------------
	
math_s16_cmp_lt

	ldy  zpWord0+1
	lda  zpWord0
	cmp  zpWord1
	tya
	sbc  zpWord1+1
	bvc  +
	eor  #$80
	+               
	bpl  math_s16_cmp_lt_else
	sec
	rts
math_s16_cmp_lt_else
	clc
	rts

; ---------------------------------------------------------------

math_s16_cmp_gt

	ldy  zpWord1+1
	lda  zpWord1
	cmp  zpWord0
	tya
	sbc  zpWord0+1
	bvc  +
	eor  #$80
	+               
	bpl  math_s16_cmp_gt_else
	sec
	rts
math_s16_cmp_gt_else
	clc
	rts

; ---------------------------------------------------------------

math_u16_cmp_lt

	ldy  zpWord0+1
	lda  zpWord0
	cpy  zpWord1+1
	bcc  +
	bne  math_u16_cmp_lt_else
	cmp  zpWord1
	bcs  math_u16_cmp_lt_else
+
	sec
	rts
math_u16_cmp_lt_else
	clc
	rts

; ---------------------------------------------------------------

math_u16_cmp_gt

	ldy  zpWord0+1
	lda  zpWord0
	cpy  zpWord1+1
	bcc  math_u16_cmp_gt_else
	bne  +
	cmp  zpWord1
	bcc  math_u16_cmp_gt_else
+               
	beq  math_u16_cmp_gt_else
	sec
	rts
math_u16_cmp_gt_else
	clc
	rts
	
;--------------------------------------------------------------- 

math_s8_cmp_eq
math_u8_cmp_eq

	lda  zpByte0
	cmp  zpByte1
	bne  +
	sec
	rts
+
	clc
	rts
	
;--------------------------------------------------------------- 

math_s8_cmp_gt

	lda  zpByte0
	clc
	sbc  zpByte1
	bvc  +
	eor  #$80
+               
	bpl  +
	bmi  math_s8_cmp_gt_else
+
	sec
	rts
math_s8_cmp_gt_else
	clc
	rts
	
;--------------------------------------------------------------- 

math_s8_cmp_lt

	lda  zpByte0
	sec
	sbc  zpByte1
	bvc  +
	eor  #$80
+               
	bpl  +
	sec
	rts
+
	clc
	rts
	
;--------------------------------------------------------------- 

math_u8_cmp_gt

	lda  zpByte0
	cmp  zpByte1
	bcc  +
	beq  +
	sec
	rts
+
	clc
	rts
	
;--------------------------------------------------------------- 

math_u8_cmp_lt

	lda  zpByte0
	cmp  zpByte1
	bcs  +
	sec
	rts
+
	clc
	rts
	
	
;;;
;;
;
