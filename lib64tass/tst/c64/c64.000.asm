

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

;--------------------------------------------------------------- main


.include "../../lib/libC64.asm"


;--------------------------------------------------------------- main


main	.proc

    .u8_type    a,1
    .s8_type    b,2
    .u16_type   a,1
    .s16_type   b,2
    
    var1    .word %1010101010101010
    
    start	.proc

            ;   program

            ; -------------------------------------  ror2_ub
            .load_var_ay var1
            sec
            jsr std.print_u16_bin
            
            lda #char.nl
            jsr c64.CHROUT

            .load_address_ay var1
            jsr mem.ror2_ub
            
            .load_var_ay var1
            sec
            jsr std.print_u16_bin
 
            lda #char.nl
            jsr c64.CHROUT
            
            ; -------------------------------------  rol2_ub
 
            .load_var_ay var1
            sec
            jsr std.print_u16_bin
            
            lda #char.nl
            jsr c64.CHROUT

            .load_address_ay var1
            jsr mem.rol2_ub
            
            .load_var_ay var1
            sec
            jsr std.print_u16_bin
 
            lda #char.nl
            jsr c64.CHROUT
            
            ; -------------------------------------
             
            rts

    .pend

.pend

;;;
;;
;

