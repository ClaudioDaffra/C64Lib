

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

    start	.proc

            ;   program
            
            ;-------------------------------------------- operation with stack

            ;                       4
            
            lda #4     
            jsr stack.push_byte

            ;                       2
            
            lda #2     
            jsr stack.push_byte

            ;                       *       8
            
            jsr stack.mul_w 

            ;                       26
            
            lda #26     
            jsr stack.push_byte

            ;                       3
            
            lda #3      
            jsr stack.push_byte

            ;                       /       8
            
            jsr stack.idiv_ub   

            ;                               +       16
            
            jsr stack.add_w 
            ;                     16
            jsr stack.pop_byte
            
            jsr std.print_u8_dec
            
            rts
    .pend

.pend

;;;
;;
;

