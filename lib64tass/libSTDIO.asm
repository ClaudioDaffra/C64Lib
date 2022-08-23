
; lib std io

;--------------------------------------------------------------- global

c64_CHROUT = $FFD2

 
hex_digits		.text '0123456789abcdef'	

;--------------------------------------------------------------- conv

conv .proc

	; convert byte in digit
	; input 	:	a byte
	; output	:	a,y digit
	
	u8_to_hex

			stx  zpx
			pha
			and  #$0f
			tax
			ldy  hex_digits,x
			pla
			lsr  a
			lsr  a
			lsr  a
			lsr  a
			tax
			lda  hex_digits,x
			ldx  zpx
			rts



.pend

;--------------------------------------------------------------- std

std .proc

	;	stampa un byte a schermo
	;	input	:	a	carattere
	;			:	sec	stampa	$ difronte al carattere

	print_dollar
			lda  #'$'
			jsr  c64_CHROUT
			rts
			
	print_u8_hex

			;stx  zpx
			bcc  +
			pha
			lda  #'$'
			jsr  c64_CHROUT
			pla
			
	print_u8_hex_digits
    
	+		jsr  conv.u8_to_hex
			jsr  c64_CHROUT
			tya
			jsr  c64_CHROUT
			;ldx  zpx
			rts
	
	print_u8_bin
	
			stx  zpx
			sta  zpa
			bcc  +
			lda  #'%'
			jsr  c64_CHROUT
            
    print_u8_bin_digits
            sta zpa
    
	+		ldy  #8
	-		lda  #'0'
			asl  zpa
			bcc  +
			lda  #'1'
	+		jsr  c64_CHROUT
			dey
			bne  -
			ldx  zpx
			rts

    ;   stampa un numero 16 bit esadecimale
    ;   input   :   a/y
    ;           :   sec aggiunge $ all'inizio
	print_u16_hex

            pha
            tya
            jsr  print_u8_hex
            pla
            clc
            jmp  print_u8_hex
            rts

	print_u16_bin
    
            pha
            tya
            jsr  print_u8_bin
            pla
            clc
            jmp  print_u8_bin
            rts
            
    ;   stampa una string , null terminated
    ;   input   :   a/y
    print_string
    
            sta  zpWord0 
            sty  zpWord0+1 
            ldy  #0
    -		lda  (zpWord0),y
            beq  +
            jsr  c64_CHROUT
            iny
            bne  -
    +		rts
    
 
    ; input :   a  unsigned byte
    print_u8_dec .proc

            tax
            lda #0
            jsr $BDCD
            
            rts
    .pend

    ; input :   ax  unsigned word
    print_u16_dec .macro

            ;lda >\1
            ;ldx <\1
            jsr $BDCD
            
            rts
    .endmacro

    ; input :   a  signed byte
    print_s8_dec .proc

            pha
            and #128
            beq +
            lda #'-'    ;   -127
            jsr  c64_CHROUT
            pla
            and #%01111111
            sta zpa
            lda #129
            sbc zpa
            pha 
    +        
            pla
            tax
            lda #0
            jsr $BDCD

            rts

    .pend 

    ; input :   ax  signed word
    print_s16_dec .proc

            stx zpx
            pha
            and #128
            beq +       ; se positvo
            
            ; negativo 
            
            lda #'-'
            jsr  c64_CHROUT

            pla
            eor #255    ;   inverti
            and #127    ;   azzera bit segno
            sta zpa
            
            lda zpx
            eor #255    ;   inverti
            clc         ;   azzera riporti
            adc #1      ;   complemento 2
            sta zpx

            lda zpa
            ldx zpx
            jsr $BDCD
            
            rts
    +        
            ; positivo
            pla
            ldx zpx
            jsr $BDCD

            rts
            
    .pend
    
;
    
.pend

;;;
;;
;
