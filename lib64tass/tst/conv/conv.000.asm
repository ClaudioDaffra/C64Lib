

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


    c1 .null   "65535:"   
    s16 .sint   -32755 
 
    print_string_out    .proc
    
            load_address_zpWord0    conv.string_out
            jsr std.print_string

            lda #char.nl
            jsr sys.CHROUT
            
            rts
    .pend
    
    start	.proc

            ;   program

            ; --------------------------------------- str_ub0
            
            lda #03
            jsr conv.str_ub0
             
            jsr print_string_out
            
            ; --------------------------------------- str_ub
            
            lda #03
            jsr conv.str_ub
             
            jsr print_string_out
            
            ; --------------------------------------- str_b
            
            lda #-3
            jsr conv.str_b
             
            jsr print_string_out
            
            ; --------------------------------------- str_ubhex
            
            lda #13
            jsr conv.str_ubhex
             
            jsr print_string_out
            
            ; --------------------------------------- str_ubbin
            
            lda #13
            jsr conv.str_ubbin
             
            jsr print_string_out
            
            ; --------------------------------------- str_uwbin

            ;   c001
            lda <#$c001
            ldy >#$c001
            jsr conv.str_uwbin
             
            jsr print_string_out

            ; --------------------------------------- str_uwhex

            ;   c001
            lda <#$c001
            ldy >#$c001
            jsr conv.str_uwhex
             
            jsr print_string_out

            ; --------------------------------------- str_uwhex

            ;   c001
            lda <#$c001
            ldy >#$c001
            jsr conv.str_uwhex
             
            jsr print_string_out
            
            ; --------------------------------------- str_uwhex

            ;   c001
            lda <#s16
            ldy >#s16
            jsr conv.str_uwhex
             
            jsr print_string_out

            ; --------------------------------------- str_uwdec 

            ;   c001
            lda #$0001
            ldy #$0001+1
            jsr conv.str_uwdec
             
            jsr print_string_out

            ; --------------------------------------- str_w 

            ;   c001
            lda s16
            ldy s16+1
            jsr conv.str_w
             
            jsr print_string_out
            
            ; --------------------------------------- 
            
            rts
            


    .pend

.pend

;;;
;;
;

