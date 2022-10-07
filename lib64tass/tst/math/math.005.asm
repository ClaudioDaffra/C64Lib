

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

            ;--------------------------------------------   div u8 / u8

            lda #23
            ldy #4
            jsr math.div_u8
            ; a result , y remainder
            pha
            tya
            pha
    
            pla
            jsr txt.print_u8_dec
            lda #' '
            jsr c64.CHROUT
            
            pla
            jsr txt.print_u8_dec
            
            lda #char.nl
            jsr c64.CHROUT


            ;--------------------------------------------  div s8 / s8

            lda #-23
            ldy #4
            jsr math.div_s8
            ; a result , y remainder
            pha
            tya
            pha
            
            pla
            jsr txt.print_u8_dec        ;   remainder always u8
            
            lda #' '
            jsr c64.CHROUT
            
            pla
            jsr txt.print_s8_dec        ;   result          s8
            
            ;-------------------------------------------- 
            
            rts
            
    .pend

.pend

;;;
;;
;

