

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

;--------------------------------------------------------------- sub

;--------------------------------------------------------------- main

main	.proc

    start	.proc

            ;   program

            ;-------------------------------------------- mul
 
            lda #char.nl
            jsr c64.CHROUT

            ;--------------------------------------------   math.mul_byte_3  (27/81)
            
            lda #27
            jsr math.mul_byte_3
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_byte_5  (27/135)
            
            lda #27
            jsr math.mul_byte_5
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_byte_6  (27/162)
            
            lda #27
            jsr math.mul_byte_6
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_byte_7  (27/189)
            
            lda #27
            jsr math.mul_byte_7
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT

            ;--------------------------------------------   math.mul_byte_9  (2/18)
            
            lda #2
            jsr math.mul_byte_9
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_byte_10  (2/20)
            
            lda #2
            jsr math.mul_byte_10
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_byte_11  (2/22)
            
            lda #2
            jsr math.mul_byte_11
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_byte_12  (2/24)
            
            lda #2
            jsr math.mul_byte_12
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_byte_13  (2/26)
            
            lda #2
            jsr math.mul_byte_13
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT

            ;--------------------------------------------   math.mul_byte_13  (2/28)
            
            lda #2
            jsr math.mul_byte_14
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT

            ;--------------------------------------------   math.mul_byte_13  (2/30)
            
            lda #2
            jsr math.mul_byte_15
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT

            ;--------------------------------------------   math.mul_byte_13  (2/40)
            
            lda #2
            jsr math.mul_byte_20
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT

            ;--------------------------------------------   math.mul_byte_13  (2/50)
            
            lda #2
            jsr math.mul_byte_25
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT

            ;--------------------------------------------   math.mul_byte_13  (2/80)
            
            lda #2
            jsr math.mul_byte_40
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT

            ;--------------------------------------------   math.mul_byte_13  (2/100)
            
            lda #2
            jsr math.mul_byte_50
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT

            ;--------------------------------------------   math.mul_byte_13  (2/160)
            
            lda #2
            jsr math.mul_byte_80
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT

            ;--------------------------------------------   math.mul_byte_13  (2/200)
            
            lda #2
            jsr math.mul_byte_100
            jsr std.print_u8_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------
            ;--------------------------------------------
            ;-------------------------------------------- 
            
            lda #char.nl
            jsr c64.CHROUT

            ;--------------------------------------------
            ;--------------------------------------------
            ;--------------------------------------------
            
            ;--------------------------------------------   math.mul_word_3  (123/369)
            
            .load_imm_ay #123
            jsr math.mul_word_3
            jsr std.print_u16_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_word_5  (123/615)
            
            .load_imm_ay #123
            jsr math.mul_word_5
            jsr std.print_u16_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_word_6  (123/738)
            
            .load_imm_ay #123
            jsr math.mul_word_6
            jsr std.print_u16_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_word_7  (123/861)
            
            .load_imm_ay #123
            jsr math.mul_word_7
            jsr std.print_u16_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_word_9  (123/1107)
            
            .load_imm_ay #123
            jsr math.mul_word_9
            jsr std.print_u16_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_word_10  (123/1230)
            
            .load_imm_ay #123
            jsr math.mul_word_10
            jsr std.print_u16_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_word_12  (123/1476)
            
            .load_imm_ay #123
            jsr math.mul_word_12
            jsr std.print_u16_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_word_15  (123/1845)
            
            .load_imm_ay #123
            jsr math.mul_word_15
            jsr std.print_u16_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_word_25  (123/3075)
            
            .load_imm_ay #123
            jsr math.mul_word_25
            jsr std.print_u16_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_word_40  (123/4920)
            
            .load_imm_ay #123
            jsr math.mul_word_40
            jsr std.print_u16_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_word_50  (123/6150)
            
            .load_imm_ay #123
            jsr math.mul_word_50
            jsr std.print_u16_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_word_320  (123/3840)
            
            .load_imm_ay #12
            jsr math.mul_word_320
            jsr std.print_u16_dec
            
            lda #' '
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.mul_word_640  (12/7680 )
            
            .load_imm_ay #12
            jsr math.mul_word_640
            jsr std.print_u16_dec

            lda #char.nl
            jsr c64.CHROUT
            
            ;--------------------------------------------   math.lsr_byte_A  (16 (3)>>2 )
            
            lda #16
            ldy #3
            jsr math.shift_right    ;  16    00010000    00000010    2
            jsr std.print_u8_dec
            
            ;
            
            rts
    .pend

.pend

;;;
;;
;

