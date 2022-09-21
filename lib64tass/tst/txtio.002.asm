
.cpu  '6502'
.enc  'none'

; ---- basic program with sys call ----

; [start address]

* = $0801
    ;           [line]
	.word  (+), 2022
    ;      [sys]                                     [rem]     [desc]
	.null  $9e, format(' %d ', program_entry_point), $3a, $8f, ' prg'
+	.word  0

program_entry_point	; assembly code starts here

	jmp main.start

;--------------------------------------------------------------- lib

.include "../lib/libC64.asm"
.include "../lib/libMath.asm"
.include "../lib/libSTDIO.asm"
.include "../lib/libConv.asm"

;--------------------------------------------------------------- main

main	.proc

    u8    .byte 123
    u16   .word 25031
    
    start	.proc

            ;   program
            
            ; .................................... print unsigned byte
            
            sec ;   print $
            lda #123
            jsr std.print_u8_hex
            
            lda #' '
            jsr sys.CHROUT

            sec ;   print %
            lda #123
            jsr std.print_u8_bin 
            
            lda #' '
            jsr sys.CHROUT

            lda u8
            jsr std.print_u8_dec 

            lda #char.nl
            jsr sys.CHROUT

            ; .................................... print unsigned word
            
            ; $61c7
            load_ay #25031
            sec
            jsr std.print_u16_hex

            lda #' '
            jsr sys.CHROUT
            
            ; 110000111000111
            load_ay #25031
            sec
            jsr std.print_u16_bin

            lda #' '
            jsr sys.CHROUT
            
            ;lda  u16+1
            ;ldx  u16
            load_var_ax u16
            jsr std.print_u16_dec

            lda #char.nl
            jsr sys.CHROUT
            
            rts

    .pend

.pend

;;;
;;
;









