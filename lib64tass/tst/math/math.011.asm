

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
            
            ;-------------------------------------------- sign

            lda #-15
            jsr math.sign
 
            sta 1024        ;   255 petscii
            
            lda #15
            jsr math.sign
 
            sta 1025        ;    1 petscii
 
            
            rts
    .pend

.pend

;;;
;;
;

