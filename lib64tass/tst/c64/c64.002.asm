

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

    s1  .null   "0123456789abcdef"  ;   16 byte

    start	.proc

            ;   program
 
            ;   ...................................... copy string at 0,0

            lda #color.white
            jsr txt.clear_color

            jsr txt.clear_screen

            ;   ......................................
            
            load_imm_zpWord0    #1024
            load_imm_xy         #256
            lda #char.a
            jsr mem.set_byte

            ;   ......................................
            
            load_imm_zpWord0    #(1024+256)
            load_imm_zpWord1    #0012
            load_imm_ay         #0102
            jsr mem.set_word

            ;   ......................................
            
            load_imm_zpWord0    #(1024)
            load_imm_zpWord1    #(1024+512)
            load_imm_xy         #2
            jsr mem.copy_npage_from_to
            
            ;   ......................................
            
            rts
 

    .pend

.pend

;;;
;;
;

