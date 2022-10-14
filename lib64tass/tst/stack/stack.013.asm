

.cpu  '6502'
.enc  'none'

; ---- basic program with sys call ----

; [start address]

* = $0801
    ;           [line]
    .word  (+), 2022
    ;      [sys]                                     [rem]     [desc]
    .null  $9e, format(' %d ', program_entry_point), $3a, $8f, ' prg'
+   .word  0

;--------------------------------------------------------------- program_entry_point

program_entry_point

    jmp program

;--------------------------------------------------------------- lib

.include "../../lib/libC64.asm"

;--------------------------------------------------------------- sub

;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

main	.proc

    save_sp .byte 0
    
    start	.proc

            ;   program
 
            ;--------------------------------------------------------------- clear
 
            jsr c64.CLEARSCR

            ;---------------------------------------------------------------
            
            lda stack.pointer
            sta save_sp

            jsr stack.debug
            
            ;-----------------------------------------------------   stack.idiv_uw

            lda #char.nl
            jsr c64.CHROUT
            
            .load_imm_ay #26
            jsr std.print_u16_dec
            
            lda #'/'
            jsr c64.CHROUT
                       
            .load_imm_ay #3
            jsr std.print_u16_dec
            
            .load_imm_ay #3
            jsr stack.push_word

            .load_imm_ay #26
            jsr stack.push_word

            lda #'='
            jsr c64.CHROUT
            
            jsr stack.idiv_uw
            ;                   A/Y        :   16 bit division result
            ;                   zpWord0
            ;                   zpWord1    :   in ZP: 16 bit remainder
            
            jsr stack.pop_word
            jsr std.print_u16_dec
            
            ;------------------------------------------------- idiv_w

            lda #char.nl
            jsr c64.CHROUT
            
            .load_imm_ay #-26
            jsr std.print_s16_dec
            
            lda #'/'
            jsr c64.CHROUT
                       
            .load_imm_ay #3
            jsr std.print_s16_dec
            
            .load_imm_ay #3
            jsr stack.push_word

            .load_imm_ay #-26
            jsr stack.push_word

            lda #'='
            jsr c64.CHROUT
            
            jsr stack.idiv_w
            ;                   A/Y        :   16 bit division result
            ;                   zpWord0
            ;                   zpWord1    :   in ZP: 16 bit remainder
            
            jsr stack.pop_word
            jsr std.print_s16_dec
            
            ;-------------------------------------------------
            
            lda #char.nl
            jsr c64.CHROUT
            
            jsr stack.debug  
            
            lda save_sp
            sta stack.pointer
            tax

            rts
            
    .pend

.pend

;;;
;;
;

