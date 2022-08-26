
;   TODO ptr   screen_ptr
;   TODO ptr   color_ptr
;   TODO   \n clr \r
;   txt.screen_ptr
;   txt_color_ptr
; lib std io

;--------------------------------------------------------------- color

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

;--------------------------------------------------------------- screen
.weak
SCREEN_ADDR =   $0400
.endweak

screen_s    .struct
    row         .byte   0
    col         .byte   0
    border      .byte   0       ;           53280   border color    
    .union
    background  .byte   0       ;   col 0   53181   background color :  color 0
    color0      .byte   0
    .endunion
    color1      .byte   0       ;   col 1   53182   extra background :  color 1
    color2      .byte   0       ;   col 2   53183   extra background :  color 2
    color3      .byte   0       ;   col 3   53184   extra background :  color 3
    .union
    foreground      .byte   0       ;   foreground color
    color_number    .byte   0       ;   00  01  10  11
    .endunion
    char        .byte   0
.endstruct

screen  .dstruct  screen_s

;---------------------------------------------------------------

txt .proc

    ; 2* 3* colore
    setscreen_with_col_2_3
            lda screen.color2
            asl
            asl
            asl
            asl
            ora screen.color3
            rts
            
    ; 4* colore     
    
    char_color_or
        .byte   %00000000
        .byte   %01000000
        .byte   %10000000
        .byte   %11000000
        
    setchar_with_color_number
    
            ldx screen.color_number
            lda screen.char
            and #%00111111
            ora txt.char_color_or,x
            sta screen.char
            rts

    ; ---- sets the character in the screen matrix at the given position
    setchar .proc
        
            lda screen.char
            ldx screen.col
            ldy screen.row
            ;pha
            tya
            asl  a
            tay
            lda  screen_rows+1,y
            sta  ptr+2
            txa
            clc
            adc  screen_rows,y
            sta  ptr+1
            bcc  +
            inc  ptr+2
    +		
            ;pla
      
            ; ext mode
            
                jsr c64.check_text_mode_extended
                if_false end
                
                jsr setchar_with_color_number
                ;lda screen.char
    end            
            lda screen.char
    ptr
            sta  $0400		; modified
            rts
        
    pointer  = setchar.ptr + 1
    screen_rows	.word  SCREEN_ADDR + range(0, 1000, 40)

    .pend

    set_border_color .proc
        lda screen.border
        sta $d020
        rts
    .pend
    
    set_background_color .proc
        lda screen.background
        sta $d021
        rts
    .pend
    
    set_foreground_color .proc
    
            ; ext mode
                jsr c64.check_text_mode_extended
                if_true end
                
            lda screen.foreground
            ldx screen.col
            ldy screen.row
            pha
            tya
            asl  a
            tay
            lda  color_rows+1,y
            sta  ptr+2
            txa
            clc
            adc  color_rows,y
            sta  ptr+1
            bcc  +
            inc  ptr+2
    +		
            pla
    ptr		
            sta  $d800		; modified
    end
            rts
            
    pointer  = set_foreground_color.ptr + 1
    color_rows	.word  $D800 + range(0, 1000, 40)

    .pend

.pend

;--------------------------------------------------------------- global

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

;--------------------------------------------------------------- char

chr_home        =   19
chr_nl          =   '\n'
chr_clearScreen =   147
chr_spc         =   ' '
chr_dollar      =   '$'

;--------------------------------------------------------------- std

std .proc

	;	stampa un byte a schermo
	;	input	:	a	carattere
	;			:	sec	stampa	$ difronte al carattere

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
