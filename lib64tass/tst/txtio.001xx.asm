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

.include "..\lib\libC64.asm"
.include "..\lib\libMath.asm"
.include "..\lib\libSTDIO.asm"

;--------------------------------------------------------------- main
stringa .null "claudio" 

;----------------------------------------------------- type

;---------------------------
signed8         .char(-30)
unsigned16      .word(8192)
signed16        .sint(-32455)

main	.proc

    start	.proc

            jmp due
            
            ; ------------------------------------- std mode
            
            lda #cOrange
            sta screen.background
            lda #cRed
            sta screen.foreground
            lda #cCyan
            sta screen.border 

            jsr c64.set_text_mode_standard_on
            
            lda #chr_clearScreen
            jsr c64_CHROUT
            
            lda #3
            sta screen.row
            lda #5
            sta screen.col 
            
            lda #1
            sta screen.char

            jsr txt.setchar           
            jsr txt.set_foreground_color   

            ;
            
            lda #5
            sta screen.row
            lda #7
            sta screen.col 
            
            jsr txt.setchar
            jsr txt.set_foreground_color 
            
            rts
            
            ; ------------------------------------- ext mode
due
            lda #cBlue
            sta screen.border 
            
            lda #cYellow
            sta screen.color0
            lda #cRed
            sta screen.color1
            lda #cGreen
            sta screen.color2
            lda #cCyan
            sta screen.color3
            
            lda #cBlack
            sta screen.foreground

            jsr c64.set_text_mode_extended_on
            
            lda #chr_clearScreen
            jsr c64_CHROUT
            
            lda #5
            sta screen.row
            lda #7
            sta screen.col 
            
            lda #1
            sta screen.char
            
            lda #03
            sta screen.color_number

            ;jsr txt.set_ext_char
            jsr txt.setchar
            ;jsr txt.set_foreground_color 
            
            rts
            

            
    .pend

.pend









