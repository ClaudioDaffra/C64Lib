

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

    start	.proc

            ;   program

            ;--------------------------------------------   div u16 / u16
 
            lda #char.nl
            jsr sys.CHROUT

            ;--------------------------------------------       unsigned 16 division
            ;             21,64            
            ; 1234 / 57 = 21,37
            
            load_imm_zpWord0    #1234
            load_imm_ay         #57
            
            jsr math.div_u16
 
            jsr std.print_u16_dec

            lda #'.'
            jsr sys.CHROUT
            
            load_var_ay zpWord1
            
            jsr std.print_u16_dec
            
            ;--------------------------------------------       unsigned 16 division / 0   
            ;65534/1    65534,1 flag v(0)
            ;65534/0    ?,?     flag v(1)
            
            lda #char.nl
            jsr sys.CHROUT
            
            load_imm_zpWord0    #65534
            load_imm_ay         #2
            
            jsr math.div_u16
            bvs divisionByZero
            ; ay result
            jsr std.print_u16_dec

            lda #'.'
            jsr sys.CHROUT
            ; zpWord1 remaider
            load_var_ay zpWord1
            
            jsr std.print_u16_dec

            ;--------------------------------------------       signed 16 division 

            lda #char.nl
            jsr sys.CHROUT
            
            ;               -745,76   
            ;  -25356/34    -745,26 
           
            load_imm_zpWord0    #-25356
            load_imm_ay         #34
            ; ay result
            jsr math.div_s16
            bvs divisionByZero

            jsr std.print_s16_dec

            lda #'.'
            jsr sys.CHROUT
            ; zpWord1 remaider
            load_var_ay zpWord1
            
            jsr std.print_u16_dec
            
            rts

divisionByZero

            lda #'0'
            sta 1024
            
            rts
    .pend

.pend

;;;
;;
;

