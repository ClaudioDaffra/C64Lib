
;**********
;           screen
;**********

screen_s    .struct
    row                 .byte   0
    col                 .byte   0
    ;
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
    ;
    char                .byte   0
    ;
    width               .byte   c64.screen_max_width
    height              .byte   c64.screen_max_height
.endstruct

screen  .dstruct  screen_s

;**********
;           txt
;**********
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

    ; ........................................... get_char

    get_char    .proc
    
            ldx screen.col
            ldy screen.row

            tya
            asl  a
            tay
            lda  set_char.screen_rows+1,y
            sta  ptr+2
            txa
            clc
            adc  set_char.screen_rows,y
            sta  ptr+1
            bcc  +
            inc  ptr+2
    +
    ptr
            lda  $0400		; modified
            rts
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
    
    ; ........................................... set_background_color
    
    set_background_color .proc
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

    get_foreground_color .proc
    
            ldx screen.col
            ldy screen.row
            pha
            tya
            asl  a
            tay
            lda  set_foreground_color.color_rows+1,y
            sta  ptr+2
            txa
            clc
            adc  set_foreground_color.color_rows,y
            sta  ptr+1
            bcc  +
            inc  ptr+2
        +		
            pla
        ptr		
            lda  $d800		; modified
        ;end
            rts

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

    clear_screen .proc
     
            lda  #' '
            ldy  #250
            jmp  clear_screen_chars

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

    clear_color .proc
     
            sta  screen.foreground_color
            jmp  clear_screen_colors

    .pend
    
    ; ........................................... screen_scroll ( left,right,up,down )
    
    screen_scroll_left    .proc
     
            stx  zpx
            bcc _scroll_screen

        +   ; scroll the screen and the color memory

            ldx  #0
            ldy  #38
        -
            .for row=0, row<=24, row+=1
                lda  c64.screen_addr    + 40*row + 1,x
                sta  c64.screen_addr    + 40*row + 0,x
                lda  c64.color_addr     + 40*row + 1,x
                sta  c64.color_addr     + 40*row + 0,x
            .next
            
            inx
            dey
            bpl  -
            rts

    _scroll_screen  ; scroll only the screen memory
    
            ldx  #0
            ldy  #38
        -
            .for row=0, row<=24, row+=1
                lda  c64.screen_addr + 40*row + 1,x
                sta  c64.screen_addr + 40*row + 0,x
            .next
            inx
            dey
            bpl  -

            ldx  zpx
            rts
            
    .pend

    screen_scroll_right    .proc
     
            stx  zpx
            bcc  _scroll_screen

        +   ; scroll the screen and the color memory
            ldx  #38
        -
            .for row=0, row<=24, row+=1
                lda  c64.screen_addr    + 40*row + 0,x
                sta  c64.screen_addr    + 40*row + 1,x
                lda  c64.color_addr     + 40*row + 0,x
                sta  c64.color_addr     + 40*row + 1,x
            .next
            dex
            bpl  -
            rts

    _scroll_screen  ; scroll only the screen memory
    
            ldx  #38
        -
            .for row=0, row<=24, row+=1
                lda  c64.screen_addr + 40*row + 0,x
                sta  c64.screen_addr + 40*row + 1,x
            .next
            
            dex
            bpl  -

            ldx  zpx
            rts
    .pend

    screen_scroll_up    .proc
     
            stx  zpx
            bcc  _scroll_screen

        +   ; scroll the screen and the color memory
    
            ldx #39
        -
            .for row=1, row<=24, row+=1
                lda  c64.screen_addr    + 40*row,x
                sta  c64.screen_addr    + 40*(row-1),x
                lda  c64.color_addr     + 40*row,x
                sta  c64.color_addr     + 40*(row-1),x
            .next
            
            dex
            bpl  -
            rts

    _scroll_screen  ; scroll only the screen memory
    
            ldx #39
        -
        
            .for row=1, row<=24, row+=1
                lda  c64.screen_addr + 40*row,x
                sta  c64.screen_addr + 40*(row-1),x
            .next
            
            dex
            bpl  -

            ldx  zpx
            rts
        .pend
    
    screen_scroll_down    .proc
     
            stx  zpx
            bcc  _scroll_screen

        +   ; scroll the screen and the color memory
    
            ldx #39
        -
            .for row=23, row>=0, row-=1
                lda  c64.screen_addr    + 40*row,x
                sta  c64.screen_addr    + 40*(row+1),x
                lda  c64.color_addr     + 40*row,x
                sta  c64.color_addr     + 40*(row+1),x
            .next
            
            dex
            bpl  -
            rts

    _scroll_screen  ; scroll only the screen memory
    
            ldx #39
        -
            .for row=23, row>=0, row-=1
                lda  c64.screen_addr + 40*row,x
                sta  c64.screen_addr + 40*(row+1),x
            .next
            
            dex
            bpl  -

            ldx  zpx
            rts
            
    .pend
    
    ; ........................................... get/set cursor position
    
    get_cursor_pos  .proc
    
            sec
            jsr sys.SCREEN_XY
            stx screen.col
            sty screen.row
            rts
            
    .pend
    
    set_cursor_pos  ;.proc
    
            ldx screen.col
            ldy screen.row
            
    set_cursor_pos_xy
    
            clc
            jsr sys.SCREEN_XY
            rts
            
    ;.pend
    
    get_screen_width  .proc
    
            jsr  sys.SCREEN_WH
            stx  screen.width
            rts
            
    .pend

    get_screen_height  .proc
    
            jsr  sys.SCREEN_WH
            sty  screen.height
            rts
            
    .pend

    get_screen_dim  .proc
    
            jsr  sys.SCREEN_WH
            stx  screen.width
            sty  screen.height
            rts
            
    .pend
    
    ; ........................................... print_string
    ;
	;	input   :   ay  ->  zpWord0 ->  string

    print_string  .proc
    
            ldy  #0
    -        
            lda  (zpWord0),y
            beq  +
            jsr  sys.CHROUT
            iny
            bne  -
    +        
            rts
            
    .pend

    ; ----------------------------------------------------------------------- print_ub0 (dec)
    ;
	;	input   :   a   ->  unsigned byte
    
    print_u8_dec0    .proc
     
            stx  zpx
            jsr  conv.ubyte2decimal
            pha
            tya
            jsr  sys.CHROUT
            pla
            jsr  sys.CHROUT
            txa
            jsr  sys.CHROUT
            ldx  zpx
            rts
            
    .pend

    ; ----------------------------------------------------------------------- print_ub (dec)
    ;   
	;	input   :   a   ->  unsigned byte

    print_u8_dec    .proc

            stx  zpx
            jsr  conv.ubyte2decimal
    _print_byte_digits
            pha
            cpy  #'0'
            beq  +
            tya
            jsr  sys.CHROUT
            pla
            jsr  sys.CHROUT
            jmp  print_ub_ones
    +       
            pla
            cmp  #'0'
            beq  print_ub_ones
            jsr  sys.CHROUT
    print_ub_ones   
            txa
            jsr  sys.CHROUT
            ldx  zpx
            rts
            
    .pend
    
    ; ----------------------------------------------------------------------- print_b (dec)
    ;   
	;	input   :   a   ->  signed byte
    
    print_s8_dec    .proc
     
            stx  zpx
            pha
            cmp  #0
            bpl  +
            lda  #'-'
            jsr  sys.CHROUT
    +        
            pla
            jsr  conv.byte2decimal
            jmp  print_u8_dec._print_byte_digits
            
    .pend

    ; ----------------------------------------------------------------------- print_ub (hex)
    ;   
	;	input   :   a   ->  unsigned byte
    
    print_u8_hex    .proc
     
            stx  zpx
            bcc  +
            pha
            lda  #'$'
            jsr  sys.CHROUT
            pla
    +        
            jsr  conv.ubyte2hex
            jsr  sys.CHROUT
            tya
            jsr  sys.CHROUT
            ldx  zpx
            rts
            
    .pend
    
    ; ----------------------------------------------------------------------- print_ub (bin)
    ;   
	;	input   :   a   ->  unsigned byte
    
    print_u8_bin    .proc
     
            stx  zpx
            sta  zpy
            bcc  +
            lda  #'%'
            jsr  sys.CHROUT
    +        
            ldy  #8
    -        
            lda  #'0'
            asl  zpy
            bcc  +
            lda  #'1'
    +        
            jsr  sys.CHROUT
            dey
            bne  -
            ldx  zpx
            rts
            
    .pend
    
    ; ----------------------------------------------------------------------- print_uw (bin)
    ; ----------------------------------------------------------------------- print_uw (hex)
    ;
	;	input   :   ay   ->  unsigned word

    print_u16_bin    .proc
     
            pha
            tya
            jsr  print_u8_bin
            pla
            clc
            jmp  print_u8_bin
            
    .pend

    print_u16_hex    .proc

            pha
            tya
            jsr  print_u8_hex
            pla
            clc
            jmp  print_u8_hex
            
    .pend

    ; ----------------------------------------------------------------------- print_u16_dec0  (dec)
    ; ----------------------------------------------------------------------- print_u16_dec   
    ;
	;	input   :   ay   ->  unsigned word
    
    print_u16_dec0    .proc
     
            stx  zpx
            jsr  conv.uword2decimal
            ldy  #0
    -        
            lda  conv.uword2decimal.decTenThousands,y
            beq  +
            jsr  sys.CHROUT
            iny
            bne  -
    +        
            ldx  zpx
            rts
            
    .pend

    print_u16_dec    .proc
     
            stx  zpx
            jsr  conv.uword2decimal
            ldx  zpx
            ldy  #0
    -        
            lda  conv.uword2decimal.decTenThousands,y
            beq  _allzero
            cmp  #'0'
            bne  _gotdigit
            iny
            bne  -
    _gotdigit
            jsr  sys.CHROUT
            iny
            lda  conv.uword2decimal.decTenThousands,y
            bne  _gotdigit
            rts
    _allzero
            lda  #'0'
            jmp  sys.CHROUT
            
    .pend
    
    ; ----------------------------------------------------------------------- print_s16_dec  (dec)
    ;
	;	input   :   ay   -> signed word
    
    print_s16_dec    .proc
      
            cpy  #0
            bpl  +
            pha
            lda  #'-'
            jsr  sys.CHROUT
            tya
            eor  #255
            tay
            pla
            eor  #255
            clc
            adc  #1
            bcc  +
            iny
    +        
            jmp  print_u16_dec
    .pend

.pend

;**********
;          std
;**********

std .proc

    ; ........................................... print_u8_hex
    ; ........................................... print_s8_hex
    ;
	;	stampa un byte a schermo
	;	input	
    ;           :	a	    carattere
	;			:	sec	    stampa	$ difronte al carattere

    
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
        + 
            ldy  #8
        - 
            lda  #'0'
			asl  zpa
			bcc  +
			lda  #'1'
        + 
            jsr  sys.CHROUT
			dey
			bne  -
			ldx  zpx
			rts

    ; ........................................... print_u16_hex
    ; ........................................... print_s16_hex
    ;
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
    ;
    ;   stampa una string , null terminated
    ;   input   :   a/y
    
    print_string    .proc
    
            sta  zpWord0 
            sty  zpWord0+1
            ldy  #0
        - 
            lda  (zpWord0),y
            beq  +
            jsr  sys.CHROUT
            iny
            bne  -
        + 
            rts
    
    .pend

    ; ........................................... input_string

    ;   input   :   a/y     address string
    ;   output  :           output  string  ,   0
    
    input_string    .proc
     
            sta  zpWord0
            sty  zpWord0+1
            ldy  #0             ; char counter = 0
        -        
            jsr  sys.CHRIN
            cmp  #$0d           ; return (ascii 13) pressed?
            beq  +              ; yes, end.
            sta  (zpWord0),y    ; else store char in buffer
            iny
            bne  -
        +        
            lda  #0
            sta  (zpWord0),y    ; finish string with 0 byte
            rts
            
    .pend

    input_string_max    .proc

            sta  zpWord0
            sty  zpWord0+1
            ldy  #0             ; char counter = 0
            inx                 ;   numer char + 0
            beq  +              ;   if 255 then end            
        -        
            jsr  sys.CHRIN
            cmp  #$0d           ; return (ascii 13) pressed?
            beq  +              ; yes, end.
            sta  (zpWord0),y    ; else store char in buffer
            dex                 ; max num char
            beq  +
            iny
            bne  -
        +        
            lda  #0
            sta  (zpWord0),y    ; finish string with 0 byte
            rts
            
    .pend
    
    ; ........................................... print_u8_dec

    ; input :   a  unsigned byte
    
    print_u8_dec .proc

            tax
            lda #0
            jsr sys.OUT_U16
            
            rts
    .pend

    ; ........................................... print_u16_dec
    ;
    ; input :   
    ;           ay  -> ax  unsigned word
    
    print_u16_dec .proc

            sta zpa
            sty zpy
            lda zpy
            ldx zpa
            
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
    ;
    ; input :   
    ;           ay  -> ax  unsigned word
    
    print_s16_dec .proc

            sta zpa
            sty zpy
            lda zpy
            ldx zpa
            
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

.pend

;;;
;;
;
