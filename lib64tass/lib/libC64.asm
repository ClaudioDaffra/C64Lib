
;---------------------------------------------------------------  C64

;---------------------------------------------------------------  bit and or

                ;76543210
bit_or_0    =   %00000000
bit_or_1    =   %00000010
bit_or_2    =   %00000100
bit_or_3    =   %00001000
bit_or_4    =   %00000000
bit_or_5    =   %00100000
bit_or_6    =   %01000000
bit_or_7    =   %10000000

bit_and_0    =  %11111111
bit_and_1    =  %11111101
bit_and_2    =  %11111011
bit_and_3    =  %11110111
bit_and_4    =  %11101111
bit_and_5    =  %11011111
bit_and_6    =  %10111111
bit_and_7    =  %01111111

;--------------------------------------------------------------- test flag

test_bit_0   .macro
    and #%00000001
.endm
test_bit_1   .macro
    and #%00000010
.endm
test_bit_2   .macro
    and #%00000100
.endm
test_bit_3   .macro
    and #%00001000
.endm
test_bit_4   .macro
    and #%00010000
.endm
test_bit_5   .macro
    and #%00100000
.endm
test_bit_6   .macro
    and #%01000000
.endm
test_bit_7   .macro
    and #%10000000
.endm

if_bit_0 .macro
        beq \1        ;   non settato     =   0
.endm
if_bit_1 .macro
        bne \1         ;  settato         =   1
.endm
   
if_true  .macro
        bcs \1        ;   non settato     =   0
.endm
if_false .macro
        bcc \1         ;  settato         =   1
.endm

;--------------------------------------------------------------- zero page

zpa		= $02
zpx		= $2a
zpy		= $52

zpByte0 = $fb
zpByte1 = $fc
zpByte2 = $fd
zpByte3 = $fe

zpWord0     = $fb
zpWord0hi   = $fb
zpWord0lo   = $fb+1

zpWord1     = $fd
zpWord1hi   = $fd
zpWord1lo   = $fd+1

    ;   basic char get not used here TODO
    ;
    ;   zpByte4  = $73
    ;   zpByte5  = $74
    ;       zpWord2  = $73

    ;   zpByte6  = $75
    ;   zpByte7  = $76
    ;       zpWord3  = $75

    ;   zpByte8  = $77
    ;   zpByte9  = $78
    ;       zpWord4  = $77

    ;   zpByte10     = $79
    ;   zpByte11     = $7A
    ;       zpWord5  = $79

    ;   zpByte12     = $7B

    ;   zpByte4 = $03   ;   3
    ;   zpByte5 = $04
    ;   zpByte6 = $05   ;   5
    ;   zpByte7 = $06

    ;   zpWord2 = $03
    ;   zpWord3 = $05

;--------------------------------------------------------------- c64 kernal

sys .proc

    CHROUT      = $FFD2     ;   a
    OUT_U16     = $BDCD     ;   ax
    PLOT        = $fff0     ;   C=1 read cursor pos(xy)   C=0 set cursor pos(xy) 
    SCREEN      = $ffed     ;   

.pend

;--------------------------------------------------------------- color

color .proc

    black          =       0               ;       0000
    white          =       1               ;       0001
    red            =       2               ;       0010
    cyan           =       3               ;       0011
    violet         =       4               ;       0100
    green          =       5               ;       0101
    blue           =       6               ;       0110
    yellow         =       7               ;       0111

    orange         =       8               ;       1000
    brown          =       9               ;       1001
    light_red      =       10              ;       1010
    dark_grey      =       11              ;       1011
    grey           =       12              ;       1100
    light_green    =       13              ;       1101
    light_blue     =       14              ;       1110
    light_grey     =       15              ;       1111

.pend

;--------------------------------------------------------------- global var

global  .proc

hex_digits		.text '0123456789abcdef'

.pend

;--------------------------------------------------------------- char

char .proc

        ;   $CHROUT

        home            =   19
        nl              =   13
        ;clear_screen   =   147    ;   restore original color
        
        ; $0400
        
        space           =   ' '
        dollar          =   '$'
        a               =   1
        b               =   2
        
.pend

;--------------------------------------------------------------- c64 subroutine

c64 .proc

        ;---------------------------------------------------------------  address
        
        .weak
        screen_addr =   $0400
        .endweak
        color_addr  =   $d800

        screen_max_width  = $28    ;   40
        screen_max_height = $19    ;   25

        ;---------------------------------------------------------------  
        
        screen_control_register_1   =   53265
        screen_control_register_2   =   53270

        ; ........................................... set mode
        
        set_text_mode_on 
        set_text_mode_standard_on
        set_bitmap_mode_off
            lda 53265
            and #%11011111  ;   bit5
            sta 53265
            
            jsr txt.set_border_color
            jsr txt.set_background_color_
            
            rts

        ; ........................................... set bitmap mode ON 
        ; ........................................... set text mode OFF 
        
        set_text_mode_off 
        set_text_mode_standard_off
        set_bitmap_mode_on
            lda 53265
            ora #%00100000
            sta 53265

            ;jsr txt.set_border_color
            ;jsr txt.set_background_color_
            
            rts 

        ; ........................................... set text extended background mode ON 
        
        set_text_mode_extended_on
            lda 53265
            ora #%01000000  ; bit 6
            sta 53265

            lda screen.border_color
            sta $d020
            
            lda screen.background_color_0
            sta $d021
            lda screen.background_color_1
            sta $d022
            lda screen.background_color_2
            sta $d023
            lda screen.background_color_3
            sta $d024

            lda screen.foreground_color
            jsr txt.clear_screen_colors
            
            rts

        ; ........................................... set text extended background mode OFF 
        
        set_text_mode_extended_off
            lda 53265
            and #%10111111
            sta 53265

            rts

        ; ........................................... set bitmap mode MC ON 
        
        set_text_mode_multicolor_on
        set_bitmap_mode_multicolor_on
            lda 53270
            ora #%00010000  ;ora #16
            sta 53270

            lda screen.border_color
            sta $d020
            lda screen.background_color_0
            sta $d021
            lda screen.background_color_1
            sta $d022
            lda screen.background_color_2
            sta $d023
            
            rts 

        ; ........................................... set bitmap mode MC OFF 
        
        set_text_mode_multicolor_off        
        set_bitmap_mode_multicolor_off
            lda 53270
            and #%11101111  ;and #239
            sta 53270
            
            rts 

        ; ........................................... set bitmap mode 320x200 on / off 
        
        set_bitmap_mode_320x200_on  .proc
            jsr set_bitmap_mode_on
            jsr set_bitmap_mode_multicolor_off
            jsr set_text_mode_extended_off
            rts
        .pend

        set_bitmap_mode_320x200_off  .proc
            jsr set_bitmap_mode_off
            jsr set_bitmap_mode_multicolor_off
            rts
        .pend

        ; ........................................... set bitmap mode 160x200 on / off 
        
        set_bitmap_mode_160x200_on  .proc
            jsr set_bitmap_mode_on
            jsr set_bitmap_mode_multicolor_on
            jsr set_text_mode_extended_off
            rts
        .pend
        
        set_bitmap_mode_160x200_off  .proc
            jsr set_bitmap_mode_off
            jsr set_bitmap_mode_multicolor_off
            rts
        .pend
        
        ; ........................................... check mode 
        
        check_text_mode_standard    .proc

                lda c64.screen_control_register_1
                test_bit_5
                if_bit_0   + 
                clc
                rts
        +
                sec
                rts
        .pend
        
        check_text_mode_extended    .proc

                lda c64.screen_control_register_1
                test_bit_6
                if_bit_1   + 
                clc
                rts
        +
                sec
                rts
        .pend
        
        check_bitmap_mode         .proc

                lda c64.screen_control_register_1
                test_bit_5
                if_bit_1   + 
                clc
                rts
        +
                sec
                rts
        .pend

        check_multi_color         .proc

                lda c64.screen_control_register_2
                test_bit_4
                if_bit_1   + 
                clc
                rts
        +
                sec
                rts
        .pend

        check_bitmap_mode_320x200   .proc
        
            jsr check_bitmap_mode
            if_false    no
            jsr check_multi_color
            if_true     no
        si
            sec
            rts
        no 
            clc
            rts
            
        .pend

        check_bitmap_mode_160x200   .proc
        
            jsr check_bitmap_mode
            if_false    no
            jsr check_multi_color
            if_false    no
        si
            sec
            rts
        no 
            clc
            rts
            
        .pend
        
.pend

; ---------------------------------------------------------------

load_ay	.macro

	lda <\1
	ldy >\1

.endm

load_var_ay	.macro

	lda \1+1
	ldy \1

.endm

load_ax	.macro

	lda >\1
	ldx <\1

.endm

load_var_ax	.macro

	lda \1+1
	ldx \1

.endm

load_address_ay	.macro

	lda #<\1
	ldy #>\1

.endm

load_address_ax	.macro

	lda #<\1
	ldx #>\1

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