
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

;--------------------------------------------------------------- text mode

c64_standard_text_mode      =   0
c64_multicolor_text_mode    =   1
c64_extended_text_mode      =   3

mode_s  .struct
    mode    .byte   0
.endstruct
  
sys
  
c64 .proc

        text_mode    .byte  0   ; 0 text   /    1 ext
        bitmap_mode  .byte  0   ; 0 320x200 /   1   160x200

        ;   set text mode ON    /   set bitmap mode OFF
 
        set_text_mode_on
        set_bitmap_mode_off
            lda 53265
            and #%11011111
            sta 53265
            rts
   
        ;   set bitmap mode ON  /   set text mode OFF
 
        set_text_mode_off
        set_bitmap_mode_on
            lda 53265
            ora #%00100000
            sta 53265
            rts 
            
        ;   set text extended background mode ON

        set_text_mode_extended_on
            lda 53265
            ora #%01000000
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