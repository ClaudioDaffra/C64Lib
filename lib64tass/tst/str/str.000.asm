

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

    temp    .brept 255                  ;   255 byte string
                .byte 0
            .endrept
            
                    ;0123467
    s1      .null   "claudio"           ;   string1
    s2      .null   "--------------"    ;   string2
    
    debug_a .proc
            lda #'['
            jsr sys.CHROUT
            
            lda zpa
           
            jsr std.print_u8_dec
            
            lda #']'
            jsr sys.CHROUT
            rts
    .pend
    
    start	.proc

            ;   program

            ; ---------------------------- length

            load_address_ay s1
            jsr string.length

            jsr std.print_u8_dec
            
            lda #char.nl
            jsr sys.CHROUT
            
            ; ---------------------------- left
            
            load_address_zpWord0    s1
            load_address_zpWord1    s2
            
            lda #5
            jsr string.left
            
            load_address_ay s2
            jsr std.print_string

            ; ---------------------------- right

            lda #char.nl
            jsr sys.CHROUT
            
            load_address_zpWord0    s1
            load_address_zpWord1    s2
            
            lda #3
            jsr string.right
            
            load_address_ay s2
            jsr std.print_string

            ; ---------------------------- mid

            lda #char.nl
            jsr sys.CHROUT

            load_address_zpWord0    s1
            load_address_zpWord1    s2

            lda #2      ;   partenza
            ldy #3      ;   lunghezza
            jsr string.mid

            load_address_ay s2
            jsr std.print_string
            
            ; ---------------------------- find char

            lda #char.nl
            jsr sys.CHROUT
            
            load_address_zpWord0    s1
            lda #'x'
            jsr string.find_char
            
            sta zpa
            jsr debug_a

            ; ---------------------------- string copy

            lda #char.nl
            jsr sys.CHROUT
            lda #char.nl
            jsr sys.CHROUT
            
            ;   zpWord0 := zpWord1
            ;
            load_address_zpWord0    s2
            load_address_zpWord1    s1
            jsr string.copy
            
            sta zpa
            jsr debug_a
            
            load_address_zpWord0    s2
            jsr std.print_string
            

            ; ---------------------------- 
            
            rts

    .pend

.pend

;;;
;;
;

