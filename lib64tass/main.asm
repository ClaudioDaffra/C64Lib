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

        jsr c64.set_std_char_mode
        jsr c64.set_mc_char_mode
        jsr c64.set_std_bitmap_mode
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
		
.pend

.pend









