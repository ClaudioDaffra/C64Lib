
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

;--------------------------------------------------------------- main

main	.proc

    temp    .null  "0123456789abcdef" ;   string
    
    start	.proc

            ;   program

            ;   ...................................... copy string at 0,0

            jsr txt.clear_screen 
            
            ldx #0
            ldy #0
            sta screen.col
            jsr txt.set_cursor_pos_xy
            
            ;   ...................................... txt.print_string
            
            load_address_zpWord0 temp
            jsr txt.print_string
            
            lda #char.nl
            jsr c64.CHROUT

            ;   ...................................... txt.print_u8_hex
            
            lda #10
            jsr txt.print_u8_hex
            
            lda #char.nl
            jsr c64.CHROUT

            ;   ...................................... txt.print_u8_dec
            
            lda #10
            jsr txt.print_u8_dec
            
            lda #char.nl
            jsr c64.CHROUT

            ;   ...................................... txt.print_u8_hex
            
            lda #10
            sec
            jsr txt.print_u8_hex
            
            lda #char.nl
            jsr c64.CHROUT

            ;   ...................................... txt.print_u8_bin
            
            lda #10
            sec
            jsr txt.print_u8_bin
            
            lda #char.nl
            jsr c64.CHROUT
            
            ;   ...................................... txt.print_s8_dec
            
            lda #-23
            jsr txt.print_s8_dec
            
            lda #char.nl
            jsr c64.CHROUT

            ;   ...................................... txt.print_u16_bin
            
            ;   11000000:00000000
            load_imm_ay #49152
            jsr txt.print_u16_bin
            clc
            lda #char.nl
            jsr c64.CHROUT

            ;   ...................................... txt. print_u16_hex
            
            ;   $c000
            load_imm_ay #49152
            sec
            jsr txt. print_u16_hex
            
            lda #char.nl
            jsr c64.CHROUT

            ;   ...................................... txt. print_u16_dec0
            
            ;   08192
            load_imm_ay #8192
            sec
            jsr txt. print_u16_dec0
            
            lda #char.nl
            jsr c64.CHROUT

            ;   ...................................... txt. print_u16_dec
            
            ;   8192
            load_imm_ay #8192
            sec
            jsr txt. print_u16_dec
            
            lda #char.nl
            jsr c64.CHROUT

            ;   ...................................... txt. print_s16_dec
            
            ;   -8192
            load_imm_ay #-8192
            sec
            jsr txt. print_s16_dec
            
            lda #char.nl
            jsr c64.CHROUT
            
            ;   ...................................... txt.clear_color
            
            lda #color.white
            jsr txt.clear_color

 
            rts

    .pend

.pend

;;;
;;
;









