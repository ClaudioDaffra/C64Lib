.cpu  '6502'
.enc  'none'


; ---- basic program with sys call ----
* = $0801
	.word  (+), 2022
	.null  $9e, format(' %d ', prog8_entrypoint), $3a, $8f, ' prog8'
+	.word  0
prog8_entrypoint	; assembly code starts here
	jmp main.start

;--------------------------------------------------------------- lib

.include "libC64.asm"
.include "libMath.asm"
.include "libSTDIO.asm"

;--------------------------------------------------------------- main
stringa .null "claudio" 



;----------------------------------------------------- type

;---------------------------
signed8         .char(-30)
unsigned16      .word(8192)
signed16        .sint(-32455)

main	.proc




start	.proc

        ;jsr c64.set_text_mode_standard_on
        ;jsr c64.set_text_mode_extended_on
        
        ;jsr c64.set_text_mode_multicolor_on
        ;jsr c64.set_bitmap_mode_on

        jsr c64.set_bitmap_mode_320x200_on
    
        ;lda c64_Screen_control_register_1
        ;test_flag_5
        ;if_flag_set     uno
        ;if_flag_not_set zero
        
        jsr c64.check_bitmap_mode_320x200
        if_true     uno
        if_false    zero        

end        
        ;jsr c64.set_bitmap_mode_off
        ;jsr c64.set_bitmap_mode_multicolor_off
        jsr c64.set_bitmap_mode_320x200_off
        
        rts
        
        jsr c64.set_text_mode_standard_on
        ;jsr c64.set_text_mode_extended_on
        ;jsr c64.set_text_mode_multicolor_on
        ;jsr c64.set_bitmap_mode_on
        rts
        
        ; -------------------------------------
        
                        lda #chr_clearScreen
                        jsr c64_CHROUT
                    
                        lda #3
                        sta screen.row
                        lda #5
                        sta screen.col

                        lda #1
                        jsr txt.setchar

                        lda #cRed
                        jsr txt.setcol

                        rts
         
                         jsr c64_CHROUT
                          
                         lda signed16
                         jsr std.print_u8_bin
                         
                         lda signed16+1
                         jsr std.print_u8_bin

                         lda signed16
                         jsr std.print_u8_hex 
                         
                         lda signed16+1
                         jsr std.print_u8_hex

                         lda signed16+1
                         ldx signed16
                         jsr std.print_s16_dec
                         
                         rts
		
lessThan
		lda #"<"
		sta 1024
		rts
		
equal
		lda #"="
		sta 1025
		rts

greaterThan
		lda #">"
		sta 1024
		rts

uno
		lda #"1"
		sta 1024
        jmp end
		rts

zero
		lda #"0"
		sta 1024
        jmp end
		rts
        
.pend

.pend









