
;--------------------------------------------------------------- conv

conv .proc

	; convert byte in digit
    
	; input 	:	a   byte
	; output	:	a,y digit
	
	u8_to_hex

			stx  zpx
			pha
			and  #$0f
			tax
			ldy  global.hex_digits,x
			pla
			lsr  a
			lsr  a
			lsr  a
			lsr  a
			tax
			lda  global.hex_digits,x
			ldx  zpx
            
			rts



.pend
