*=	$C000

CIA2_PORT = $DD00
CIA2_DIR  = $DD02

VIC_MODECR = $D011
VIC_PTRCR  = $D018

SCRNBUF   = $6000
COLORBUF  = $4400
FONTBUF   = $4800
FONTSBUF  = $5000

XPOS      = $F7
YPOS      = $F8
SCRNPTR   = $F9     ;   $F9$FA
STRPTR    = $FB     ;   $FB$FC
PRINTPTR  = $FD     ;   $FD$FE
STRLEN    = $FF

cd:
    jmp start
    
;----------------------------------------puts_hackstr: Helper macro used by puts-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
puts_hackptr    .macro  src, dest
	lda (STRPTR),y  ; Load in the current char
	asl a			; Index the 256x8-buffer of
	asl a			; character data: <<3
	asl a
	clc			    ; Add on what's left to
	adc #<\src		; the low byte of "src"
	sta \dest+1		; Hack the STA's low byte
	lda (STRPTR),y  ; Re-load the char
	lsr a			; We lost the top 3 bits
	lsr a			; through shifting above,
	lsr a			; so >>5 to get them
	lsr a
	lsr a
	clc			    ; Add on the top 3 bits
	adc #>\src		; to the high byte
	sta \dest+2		; Hack STA's high byte
.endmacro

;----------------------------------------puts: Print a string-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
puts .proc

	; Find the length of the string first of all
	ldy #0
len:	
    lda (STRPTR),y
	and #$E0
	beq lenend		; Terminate at control char
	iny
	jmp len
lenend:	
    sty STRLEN

	; If the length came back as 0, nothing to do!
	cpy #0
	beq jpend1
	bne cont1
jpend1: 
    jmp end

cont1:	
    ldy #0			; Y will be our string index

	; Are we starting halfway through a cell?
	lda XPOS
	lsr a			; If odd, carry will set
	bcc main		; If even, drop over "fhalf"

	; Render the first half-cell of the string
fhalf:	puts_hackptr FONTBUF, fpt2

	tya			; Y is needed for addressing
	pha			; so save it on stack

	ldy #7
fpt1:	
    lda (SCRNPTR),y		; Load in the framebuffer
fpt2:	
    ora FONTBUF,y		; Shove in the char low nybble
	sta (SCRNPTR),y		; And put it back
	dey
	bpl fpt1		; From 7 to 0 inclusive

	pla			    ; Get Y back from stack
	tay

	; 16-bit add: SCRNPTR+=8
	clc
	lda SCRNPTR
	adc #8
	sta SCRNPTR
	lda SCRNPTR+1
	adc #0
	sta SCRNPTR+1

	; Move along one on screen, and in the string
	iny
	inc XPOS

	; End for 1-character strings
	cpy STRLEN
	beq jpend2
	bne main
jpend2:	
    jmp end

	; Main loop: render all full cells in the string
main:	
    puts_hackptr FONTSBUF, mpt1
	iny

	cpy STRLEN		    ; If we hit the end, in the middle
	bne mwr1		    ; of a cell, write NULL for the
	lda #<FONTBUF		; second half of the cell
	sta mpt2+1
	lda #>FONTBUF
	sta mpt2+2
	jmp mpt0

mwr1:	
    puts_hackptr FONTBUF, mpt2

mpt0:	
    tya
	pha

	ldy #7
mpt1:	
    lda FONTSBUF,y		; Load in the high nybble char
mpt2:	
    ora FONTBUF,y		; Slap the low one against it
	sta (SCRNPTR),y		; Store the result in current cell
	dey
	bpl mpt1

	pla
	tay

	lda (STRPTR),y  ; If we're at the null terminator
	and #$E0		; or any other control char
	beq mend		; don't inc XPOS twice, and stay
                    ; in this screen cell

	inc XPOS		; Cell's second character: XPOS++

	clc			; 16-bit add, move cell
	lda SCRNPTR
	adc #8
	sta SCRNPTR
	lda SCRNPTR+1
	adc #0
	sta SCRNPTR+1

mend:	
    iny			; Hop along in the string
	inc XPOS

	tya			; Are we at the end of the string?
	sec			; curr-STRLEN+1 can tell us
	sbc STRLEN		; If -ve, full cells remain
	clc			; If 0, there's half a cell left
	adc #1			; if 1, we're done
	bmi main
	bne end

	; Render the back half-cell, if required
bhalf:	puts_hackptr FONTSBUF, bpt1

	ldy #7
bpt1:	
    lda FONTSBUF,y		; Only the high nybble is needed
	sta (SCRNPTR),y		; So shove that on screen
	dey
	bpl bpt1

	inc XPOS

end:	rts			; All done
.endproc

;----------------------------------------print: Print a string, handling control characters-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
print .proc

	ldy #0			; Start at char #0

main:	
    lda (PRINTPTR),y	; Check the current char
	beq end			    ; If NULL, end
	and #$E0		    ; If a control character
	beq ctrl		    ; jump into control handling

	; Handle normal string pieces
	tya			; If this is a normal string piece
	adc PRINTPTR		; Tack Y onto the printptr
	sta STRPTR		; And assign to strptr
	lda #0
	adc PRINTPTR+1
	sta STRPTR+1

	tya			; Save Y on the stack
	pha
	jsr puts		; print the string
	pla			; and get Y back
	adc STRLEN		; Tack on the calculated length
	bcs end			; If we overflow, give up
	tay			; Otherwise, put this back in Y
	jmp main		; and do the next piece

	; Handle control characters
ctrl:	
    lda (PRINTPTR),y
	iny
	cmp #$0A		; New line
	beq newl
	jmp main		; If not handled, do the next piece

	; Handle newline
newl:	
    lda #0
	sta XPOS		; Reset X position
	inc YPOS		; Y position ++

	lda #>SCRNBUF		; scrnptr = scrnbuf + (Y*256)
	clc
	adc YPOS
	sta SCRNPTR+1
	lda #<SCRNBUF
	sta SCRNPTR

	lda YPOS		; scrnptr += (Y*64)
	asl a			; Get low byte of (Y*64)
	asl a
	asl a
	asl a
	asl a
	asl a
	clc
	adc SCRNPTR		; Add to low byte of scrnptr
	sta SCRNPTR
	lda SCRNPTR+1		; If carry, add that to high byte
	adc #0
	sta SCRNPTR+1

	lda YPOS		; Get high byte of (Y*64)
	lsr a
	lsr a
	and #$03		; Mask off the result
	clc
	adc SCRNPTR+1		; And tack it onto high byte
	sta SCRNPTR+1		; of scrnptr

	jmp main		; Back to do the next piece

end:	
    rts			; All done
.endproc

;----------------------------------------Data-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fontfile:

    .binary "ansi.font"
    ;.include "inc_charset1_40x25.s"
    ;.binary "c64_us_lower.bin"
    ;.include "charset.s"
    
; 128 char

teststr:	
		;.text "ABCDabcd ", 10
		;.text "!£$%&/()=?", 10
		;.text " qwertyuiopasdfghjklzxcvbnm", 10
		;.text "+*-:;,.", 10
		;.text ".", 0
        
       
		.for i := 1, i < 128, i += 1
		.text i
		.endfor
		.byte 0
        
		;.text   "a" ;   asci 65
		;.text   1
		;.text   "b"
		;.text   65
		;.text   "c"
		;.text 0
        
start:
	; Point the VIC to bank 2, by setting the CIA2 port's
	; bottom two bits (which act as A14/A15 for the VIC)
	; NOTE: A14/A15 are inverted from these bits
	lda CIA2_DIR
	ora #$03
	sta CIA2_DIR
	lda CIA2_PORT
	and #$FC
	ora #$02
	sta CIA2_PORT

	; Switch the VIC into bitmap mode ($11, bit 5)
	lda VIC_MODECR
	ora #$20
	sta VIC_MODECR

	; Use the top half of the bank for bitmap data, by
	; pointing the VIC there ($18, bit 3); also use the
	; 7-8k block for color data (bits 4-7)
	lda VIC_PTRCR
	and #$F7
	ora #$08
	sta VIC_PTRCR

	; Clear out the bitmap buffer, with a self-modifying
	; loop to run through the pages
	lda #0
	ldx #32			; 32 pages x 256 = 8192
	ldy #0
bset0:	
    sta SCRNBUF,y
	iny
	bne bset0		; inner loop end
	inc bset0+2		; Hack STA instr to change page
	dex
	bne bset0

	; Clear out the color buffer by writing to each page
	; of the 4-page buffer in parallel
	lda #$10		; Grey on black
	ldy #0
bset1:	
    sta $4400,y
	sta $4500,y
	sta $4600,y
	sta $4700,y
	dey
	bne bset1

	; Build the font buffers from the font file
	; The file contains 256 8-byte characters, each byte
	; being 4-bits repeated in each nybble
	ldx #8
	ldy #0
bset2:	
    lda fontfile,y		; Load in a fontfile byte
	and #$0F		    ; Grab the low nybble
bset2i:	
    sta FONTBUF,y		; And store in the Low buffer
bset2j:	
    lda fontfile,y
	and #$F0		    ; Grab the high nybble
bset2k:	
    sta FONTSBUF,y		; And store in the High buffer
	iny
	bne bset2		    ; inner loop end
	inc bset2+2		    ; Hack each LDA/STA to change page
	inc bset2i+2
	inc bset2j+2
	inc bset2k+2
	dex
	bne bset2

	; Initialise required variables
	lda #<SCRNBUF
	sta SCRNPTR
	lda #>SCRNBUF
	sta SCRNPTR+1
	lda #0
	sta XPOS
	sta YPOS

    jmp skip
    
	; Print out a test string
	lda #<teststr
	sta PRINTPTR
	lda #>teststr
	sta PRINTPTR+1
	jsr print

    rts
    
skip

    ldx #$0

lup1    
    lda fontfile+255*0,x
    sta $6000+255*0,x
    inx 
    bne lup1
    
lup2    
    lda fontfile+255*1,x
    sta $6000+255*1,x
    inx 
    bne lup2

lup3    
    lda fontfile+255*2,x
    sta $6000+255*2,x
    inx 
    bne lup3
    
lup4    
    lda fontfile+255*3,x
    sta $6000+255*3,x
    inx 
    bne lup4

    
lp:	
    jmp lp


;;;
;;
;
