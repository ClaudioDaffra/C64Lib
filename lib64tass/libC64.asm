
; C64

;--------------------------------------------------------------- c64 kernal

c64_CHROUT = $FFD2
c64_Screen_control_register_1   =   53265
c64_Screen_control_register_2   =   53270

                ;76543210
bit_or_0    =   %00000000
bit_or_1    =   %00000010
bit_or_2    =   %00000100
bit_or_3    =   %00001000
bit_or_4    =   %00000000
bit_or_5    =   %00100000
bit_or_6    =   %01000000
bit_or_7    =   %10000000

bit_and_0    =   %11111111
bit_and_1    =   %11111101
bit_and_2    =   %11111011
bit_and_3    =   %11110111
bit_and_4    =   %11101111
bit_and_5    =   %11011111
bit_and_6    =   %10111111
bit_and_7    =   %01111111

;--------------------------------------------------------------- test flag

test_flag_0   .macro
    and #%00000001
.endm
test_flag_1   .macro
    and #%00000010
.endm
test_flag_2   .macro
    and #%00000100
.endm
test_flag_3   .macro
    and #%00001000
.endm
test_flag_4   .macro
    and #%00010000
.endm
test_flag_5   .macro
    and #%00100000
.endm
test_flag_6   .macro
    and #%01000000
.endm
test_flag_7   .macro
    and #%10000000
.endm

if_flag_not_set .macro
        beq \1        ;   non settato     =   0
.endm
if_flag_set .macro
        bne \1         ;  settato         =   1
.endm
        
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

;--------------------------------------------------------------- text mode
; TODO check modalità con i rispettivi bit

c64 .proc

        text_mode    .byte  0   ; 0 text   /    1 ext
        bitmap_mode  .byte  0   ; 0 320x200 /   1   160x200

        ;   set text mode ON    /   set bitmap mode OFF
 
        set_text_mode_on 
        set_text_mode_standard_on
        set_bitmap_mode_off
            lda 53265
            and #%11011111  ;   bit5
            sta 53265

            rts
   
        ;   set bitmap mode ON  /   set text mode OFF

        set_text_mode_off 
        set_text_mode_standard_off
        set_bitmap_mode_on
            lda 53265
            ora #%00100000
            sta 53265

            rts 
            
        ;   set text extended background mode ON

        set_text_mode_extended_on
            lda 53265
            ora #%01000000  ; bit 6
            sta 53265

            rts
        
        ;   set text extended background mode OFF

        set_text_mode_extended_off
            lda 53265
            and #%10111111
            sta 53265

            rts

        ;   set bitmap mode MC ON 

        set_text_mode_multicolor_on
        set_bitmap_mode_multicolor_on
            lda 53270
            ora #16
            sta 53270
            rts 

        ;   set bitmap mode MC OFF 

        set_text_mode_multicolor_off        
        set_bitmap_mode_multicolor_off
            lda 53270
            and #239
            sta 53270
            rts 

.pend


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