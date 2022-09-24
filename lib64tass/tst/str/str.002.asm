

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

                    ;0123467
    s1      .null   "claudio"   ;   string1
    px      .null   "*cl*"     ;   pattern matchiing
    
    debug_a .proc
        lda #'['
        jsr sys.CHROUT
        
        lda zpa
        pha
        jsr std.print_s8_dec
        
        lda #']'
        jsr sys.CHROUT
        pla
        sta zpa
        
        rts
.pend
    
    start	.proc

            ;   program

            ; ......................................... upper lower
            
            load_address_zpWord0    s1
            jsr std.print_string
            
            lda #char.nl
            jsr sys.CHROUT
            lda #char.nl
            jsr sys.CHROUT
            
            load_address_zpWord0    s1
            jsr string.upper
            load_address_zpWord0    s1
            jsr std.print_string
            
            lda #char.nl
            jsr sys.CHROUT
            
            load_address_zpWord0    s1
            jsr string.lower
            load_address_zpWord0    s1
            jsr std.print_string
            
            lda #char.nl
            jsr sys.CHROUT

            ; ......................................... pattern matching

            load_address_zpWord0    s1
            jsr std.print_string
            lda #char.nl
            jsr sys.CHROUT
            load_address_zpWord0    px
            jsr std.print_string
            lda #char.nl
            jsr sys.CHROUT
            
            load_address_zpWord0   s1
            load_address_zpWord1   px
            jsr string.pattern_match
            
            sta zpa
            
            if_true   write1
            if_false  write0
end

            jsr debug_a
            
            rts

write1      
            lda #'1'
            sta 1024
            jmp end
write0      
            lda #'0'
            sta 1024
            jmp end

    .pend

.pend

;;;
;;
;
