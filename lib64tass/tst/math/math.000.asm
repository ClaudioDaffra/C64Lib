

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

    au8   .byte    1
    bu8   .byte    2
    cu8   .byte    1
    
    as8   .char   -1
    bs8   .char    2
    cs8   .char   -3

    debug_carry .proc
        lda #'0'
        adc #0
        rts
    .pend
    
    start	.proc

            ;   program
 
            ;  .................................... compare u8  ?= 0
            ; 0010
            ; 0001
            ; 1100
            
            load_zpByte0    au8
            load_zpByte1    bu8
            jsr math.u8_cmp_eq

            jsr debug_carry
            sta 1024

            ;  .................................... compare s8  ?= 0
            load_zpByte0    as8
            load_zpByte1    bs8
            jsr math.s8_cmp_eq

            jsr debug_carry
            sta 1025

            ;  .................................... compare u8  ?= 1
            load_zpByte0    au8
            load_zpByte1    cu8
            jsr math.u8_cmp_eq

            jsr debug_carry
            sta 1026

            ;  .................................... compare s8  ?= 0
            load_zpByte0    as8
            load_zpByte1    cs8
            jsr math.s8_cmp_eq

            jsr debug_carry
            sta 1027
            
            ;

            ;  .................................... compare u8  > 0
            load_zpByte0    au8
            load_zpByte1    bu8
            jsr math.u8_cmp_gt

            jsr debug_carry
            sta 1024+40

            ;  .................................... compare s8  > 0
            load_zpByte0    as8
            load_zpByte1    bs8
            jsr math.s8_cmp_gt

            jsr debug_carry
            sta 1025+40

            ;  .................................... compare u8  > 0
            load_zpByte0    au8
            load_zpByte1    cu8
            jsr math.u8_cmp_gt

            jsr debug_carry
            sta 1026+40

            ;  .................................... compare s8  > 1
            load_zpByte0    as8
            load_zpByte1    cs8
            jsr math.s8_cmp_gt

            jsr debug_carry
            sta 1027+40
            
            ;

            ;  .................................... compare u8  < 1
            load_zpByte0    au8
            load_zpByte1    bu8
            jsr math.u8_cmp_lt

            jsr debug_carry
            sta 1024+80

            ;  .................................... compare s8  < 1
            load_zpByte0    as8
            load_zpByte1    bs8
            jsr math.s8_cmp_lt

            jsr debug_carry
            sta 1025+80

            ;  .................................... compare u8  < 0
            load_zpByte0    au8
            load_zpByte1    cu8
            jsr math.u8_cmp_lt

            jsr debug_carry
            sta 1026+80

            ;  .................................... compare s8  < 0
            load_zpByte0    as8
            load_zpByte1    cs8
            jsr math.s8_cmp_lt

            jsr debug_carry
            sta 1027+80
            
            rts
 

    .pend

.pend

;;;
;;
;

