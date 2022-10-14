

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

                    ;0123467
    s1      .null   "claudio"    ;   string1
    s2      .null   "daffra"     ;   string2
    s3      .null   "claudio"    ;   string3
    gt      .null   "gt"
    eq      .null   "eq"
    lt      .null   "lt"
    
    debug_a .proc
            lda #'['
            jsr c64.CHROUT
            
            lda zpa
            pha
            jsr std.print_s8_dec
            
            lda #']'
            jsr c64.CHROUT
            pla
            sta zpa
            
            rts
    .pend
    
    start	.proc

            ;   program

            ; ---------------------------- compare

            ;   claudio daffra  s1 s2   ->  -1
            ;   claudio claudio s1 s1   ->   0
            ;   daffra  claudio s2 s1   ->   1
            
            .load_address_zpWord0    s1
            .load_address_zpWord1    s2
            
            jsr string.compare

            sta zpa
            jsr debug_a 

            .if_string_eq    label_eq
            .if_string_gt    label_gt
            .if_string_lt    label_lt
            
            jmp fine

label_eq
            .load_address_zpWord0    eq
            jsr std.print_string
            jmp fine
label_gt
            .load_address_zpWord0    gt
            jsr std.print_string
            jmp fine
label_lt
            .load_address_zpWord0    lt
            jsr std.print_string
            jmp fine
            
            ; ...
fine
            rts

    .pend

.pend

;;;
;;
;

