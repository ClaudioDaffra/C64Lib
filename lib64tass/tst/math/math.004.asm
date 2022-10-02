

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

.include "../../lib/libC64.asm"
.include "../../lib/libMath.asm"
.include "../../lib/libSTDIO.asm"
.include "../../lib/libConv.asm"
.include "../../lib/libString.asm"


;--------------------------------------------------------------- main

main	.proc

    au16    .word    1
    bu16    .word    2

    as16    .sint   -1
    bs16    .sint    2

    start	.proc

            ;   program

            ;--------------------------------------------   mul bytes

            lda #8
            ldy #3
            jsr math.mul_u8         ;   mul_bytes
            jsr std.print_u8_dec    ;   unsigned

            lda #8
            ldy #-3
            jsr math.mul_s8         ;   mul_bytes
            jsr std.print_s8_dec    ;   signed

            ;--------------------------------------------   mul bytes into word
            
            lda #char.nl
            jsr sys.CHROUT
            
            ;   40*24   =    960
            ;   40*25   =   1000
            lda #25 
            ldy #40 
            jsr math.mul_bytes_into_u16
            jsr std.print_u16_dec

            ;--------------------------------------------   mul words in dwords

            lda #char.nl
            jsr sys.CHROUT
            
            load_imm_zpWord0    #1234
            load_imm_zpWord1    #5678
            jsr math.multiply_words
            
            ;   $BCE96A00
            
            lda zpDWord0+3
            jsr std.print_u8_hex
            lda zpDWord0+2
            jsr std.print_u8_hex
            lda zpDWord0+1
            jsr std.print_u8_hex
            lda zpDWord0+0
            jsr std.print_u8_hex
            
            ;
            
            rts
            
    .pend

.pend

;;;
;;
;

