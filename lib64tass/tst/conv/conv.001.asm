

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




    
;--------------------------------------------------------------- main


main	.proc


    var_u8      .byte    3
    var_u16     .word    0

    var_s8      .char   -3
 
    
    print_var   .proc
    
            lda var_s8
            sec
            jsr std.print_s8_dec
            
            lda #char.nl
            jsr sys.CHROUT

            rts
    .pend
    
    start	.proc

            ;   program

            ;   ......................................... signed ext
            
 
            lda var_s8
            sec
            jsr std.print_s8_dec
            
            lda #char.nl
            jsr sys.CHROUT

            lda var_s8
            
            jsr conv.byte_to_word
            
            lda #char.nl
            jsr sys.CHROUT
            
            load_var_ay zpWord0
            sec
            jsr std.print_s16_dec

            ;   ......................................... unsignedext
            
            lda #char.nl
            jsr sys.CHROUT
            
            lda var_u8
            sec
            jsr std.print_u8_dec
            
            lda #char.nl
            jsr sys.CHROUT

            lda var_u8
            
            conv_byte_to_word var_u16
            
            lda #char.nl
            jsr sys.CHROUT
            
            load_var_ay var_u16
            sec
            jsr std.print_u16_dec
            
            rts
            


    .pend

.pend

;;;
;;
;

