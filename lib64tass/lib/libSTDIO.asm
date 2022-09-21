
;   TODO directory LIB
;   ODO directory example


;   TODO ptr   screen_ptr
;   TODO ptr   color_ptr
;   TODO   \n clr \r
;   txt.screen_ptr
;   txt_color_ptr
; lib std io

;--------------------------------------------------------------- screen

screen_s    .struct
    row                 .byte   0
    col                 .byte   0
    border_color        .byte   0       ;           53280   border_color color    
    .union
    background_color    .byte   0       ;   col 0   53181   background color :  color 0
    background_color_0  .byte   0
    .endunion
    background_color_1  .byte   0       ;   col 1   53182   extra background :  color 1
    background_color_2  .byte   0       ;   col 2   53183   extra background :  color 2
    background_color_3  .byte   0       ;   col 3   53184   extra background :  color 3
    .union
    foreground_color        .byte   0   ;   foreground_color color
    background_color_number .byte   0   ;   00  01  10  11
    .endunion
    char        .byte   0
.endstruct

screen  .dstruct  screen_s

;---------------------------------------------------------------

txt .proc

    ; ........................................... set_char_with_col_2_3
    ;
    ; 2* 3* colore
    
    set_char_with_col_2_3
    
            lda screen.background_color_2
            asl
            asl
            asl
            asl
            ora screen.background_color_3
            rts
            
    ; 4* colore     
    
    ; ........................................... char_color_or
    
    char_color_or
    
        .byte   %00000000
        .byte   %01000000
        .byte   %10000000
        .byte   %11000000

    ; ........................................... set_char_with_color_number
    
    set_char_with_color_number
    
            ldx screen.background_color_number
            lda screen.char
            and #%00111111
            ora txt.char_color_or,x
            sta screen.char
            rts

    ; ........................................... set_char

    set_char .proc
        
            lda screen.char
            ldx screen.col
            ldy screen.row

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
            ; ext mode
            
                jsr c64.check_text_mode_extended
                if_false end
                
                jsr set_char_with_color_number

    end            
            lda screen.char
    ptr
            sta  $0400		; modified
            rts
        
    pointer  = set_char.ptr + 1
    screen_rows	.word  c64.screen_addr + range(0, 1000, 40)

    .pend

    ; ........................................... set_cc ( row,col,char,col )
    
    set_cc   .proc 
        ;  screen.col, screen.row, screen.char, screen.foreground_color  
        ;  set char+color at the given position on the screen
        ;  screen_addr FIX $0400 , color_addr FIX $d800 
            lda  screen.row
            asl  a
            tay
            lda  set_char.screen_rows+1,y
            sta  screen_ptr+2
            adc  #$d4
            sta  color_ptr+2
            lda  set_char.screen_rows,y
            clc
            adc  screen.col
            sta  screen_ptr+1
            sta  color_ptr+1
            bcc  +
            inc  screen_ptr+2
            inc  color_ptr+2
    +		
            lda  screen.char
            
    screen_ptr	
            sta  $ffff		; modified
            lda  screen.foreground_color
    color_ptr	
            sta  $ffff		; modified
            rts
    screen_pointer  = set_cc.screen_ptr + 1
    color_pointer   = set_cc.color_ptr  + 1
     
    .pend
    
    ; ........................................... set_border_color
    
    set_border_color .proc
        lda screen.border_color
        sta $d020
        rts
    .pend
    
    ; ........................................... set_background_color_
    
    set_background_color_ .proc
        lda screen.background_color
        sta $d021
        rts
    .pend
    
    ; ........................................... set_foreground_color
    
    set_foreground_color .proc
    
            lda screen.foreground_color
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
    ;end
            rts
            
    pointer  = set_foreground_color.ptr + 1
    color_rows	.word  c64.color_addr + range(0, 1000, 40)

    .pend
    
    ; ........................................... clear_screen_chars
    
    clear_screen_chars    .proc
     
            ldy  #250
    -        
            sta  c64.screen_addr+250*0-1,y
            sta  c64.screen_addr+250*1-1,y
            sta  c64.screen_addr+250*2-1,y
            sta  c64.screen_addr+250*3-1,y
            dey
            bne  -
            
            rts

    .pend
    
    ; ........................................... clear_screen_colors
    
    clear_screen_colors    .proc

            ldy  #250
    -        
            sta  c64.color_addr+250*0-1,y
            sta  c64.color_addr+250*1-1,y
            sta  c64.color_addr+250*2-1,y
            sta  c64.color_addr+250*3-1,y
            dey
            bne  -
            rts
    .pend



.pend

;--------------------------------------------------------------- std

std .proc

    ; ........................................... print_u8_hex
    ; ........................................... print_s8_hex
    
	;	stampa un byte a schermo
	;	input	:	a	carattere
	;			:	sec	stampa	$ difronte al carattere

    
	print_u8_hex
    print_s8_hex
    
			bcc  +
			pha
			lda  #'$'
			jsr  sys.CHROUT
			pla
			
	print_u8_hex_digits
    
	+		jsr  conv.u8_to_hex
			jsr  sys.CHROUT
			tya
			jsr  sys.CHROUT
			rts

    ; ........................................... print_u8_bin
    ; ........................................... print_s8_bin
    
	print_u8_bin
	print_s8_bin
    
			stx  zpx
			sta  zpa
			bcc  +
			lda  #'%'
			jsr  sys.CHROUT
            
    print_u8_bin_digits
    
            lda zpa
    
	+		ldy  #8
	-		lda  #'0'
			asl  zpa
			bcc  +
			lda  #'1'
	+		jsr  sys.CHROUT
			dey
			bne  -
			ldx  zpx
			rts

    ; ........................................... print_u16_hex
    ; ........................................... print_s16_hex
    
    ;   stampa un numero 16 bit esadecimale
    ;   input   :   a/y
    ;           :   sec aggiunge $ all'inizio
    
	print_u16_hex
	print_s16_hex
    
            pha
            tya
            jsr  print_u8_hex
            pla
            clc
            jmp  print_u8_hex
            rts

	print_u16_bin
	print_s16_bin
    
            pha
            tya
            jsr  print_u8_bin
            pla
            clc
            jmp  print_u8_bin
            rts

    ; ........................................... print_string
    
    ;   stampa una string , null terminated
    ;   input   :   a/y
    
    print_string
    
            sta  zpWord0 
            sty  zpWord0+1 
            ldy  #0
    -		lda  (zpWord0),y
            beq  +
            jsr  sys.CHROUT
            iny
            bne  -
    +		rts
    

    ; ........................................... print_u8_dec

    ; input :   a  unsigned byte
    
    print_u8_dec .proc

            tax
            lda #0
            jsr sys.OUT_U16
            
            rts
    .pend

    ; ........................................... print_u16_dec
    ; input :   ax  unsigned word
    
    print_u16_dec .proc

            jsr sys.OUT_U16
            
            rts
    .pend

    ; ........................................... print_s8_dec
    ; input :   a  signed byte
    
    print_s8_dec .proc

            pha
            and #128
            beq +
            lda #'-'    ;   -127
            jsr  sys.CHROUT
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
            jsr sys.OUT_U16

            rts

    .pend 

    ; ........................................... print_s16_dec
    ; input :   ax  signed word
    
    print_s16_dec .proc

            stx zpx
            pha
            and #128
            beq +       ; se positvo
            
            ; negativo 
            
            lda #'-'
            jsr  sys.CHROUT

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
            jsr sys.OUT_U16
            
            rts
    +        
            ; positivo
            pla
            ldx zpx
            jsr sys.OUT_U16

            rts

    .pend
    
;
    
.pend

;;;
;;
;