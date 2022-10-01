

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

    au8   .byte    1
    bu8   .byte    2
    cu8   .char    1
    
    as8   .char   -1
    bs8   .char    2
    cs8   .char   -1


    debug_carry .proc
        lda #'0'
        adc #0
        
        rts
    .pend
    
    start	.proc

            ;   program
 
            ;  .................................... compare u8/s8 
            ;  0101
            ;  1111

            ;  ---------------------------------------------- ge
            ;   1 >= 2
            load_zpByte0    au8
            load_zpByte1    bu8
            jsr math.u8_cmp_ge
            jsr debug_carry
            sta 1024
 
            ;   1 >= 1
            load_zpByte0    au8
            load_zpByte1    cu8
            jsr math.u8_cmp_ge
            jsr debug_carry
            sta 1025
            
            ;   -1 >= 2
            load_zpByte0    as8
            load_zpByte1    bs8
            jsr math.s8_cmp_ge
            jsr debug_carry
            sta 1026

            ;   -1 >= -1
            load_zpByte0    as8
            load_zpByte1    cs8
            jsr math.s8_cmp_ge
            jsr debug_carry
            sta 1027
            
            ;

            ;   1 <= 2
            load_zpByte0    au8
            load_zpByte1    bu8
            jsr math.u8_cmp_le
            jsr debug_carry
            sta 1024+40
            
            ;   -1 <= 2
            load_zpByte0    as8
            load_zpByte1    bs8
            jsr math.s8_cmp_le
            jsr debug_carry
            sta 1025+40

            ;   1 <= 1
            load_zpByte0    au8
            load_zpByte1    cu8
            jsr math.u8_cmp_le
            jsr debug_carry
            sta 1026+40
            
            ;   -1 <= -1
            load_zpByte0    as8
            load_zpByte1    cs8
            jsr math.s8_cmp_le
            jsr debug_carry
            sta 1027+40
            
            rts
 

    .pend

.pend

;;;
;;
;

