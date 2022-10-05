

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
.include "../../lib/libMath.asm"
.include "../../lib/libSTDIO.asm"
.include "../../lib/libConv.asm"
.include "../../lib/libString.asm"


;--------------------------------------------------------------- sub
 
;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

main	.proc

    debug_stack .proc
    
            lda #'['
            jsr sys.CHROUT
            
            sec
            lda stack.pointer
            jsr std.print_u8_hex
            
            lda #']'
            jsr sys.CHROUT
            
            rts
    .pend

    save_sp .byte 0
    
    start	.proc

            ;   program
 
            ;--------------------------------------------------------------- clear
 
            jsr sys.CLEARSCR

            ;---------------------------------------------------------------
            
            lda stack.pointer
            sta save_sp
            
            ;-----------------------------------------------------   stack shift left

            lda #char.nl
            jsr sys.CHROUT
            
            load_imm_ay #123
            
            jsr stack.push_word
            
            jsr stack.shift_left_w_3  ; 984 <<3 123
            
            jsr stack.pop_word
            
            jsr std.print_u16_dec
            
            ;-----------------------------------------------------   stack shift right

            lda #char.nl
            jsr sys.CHROUT
            
            load_imm_ay #984
            
            jsr stack.push_word
            
            jsr stack.shift_right_w_3  ; 984 3>> 123
            
            jsr stack.pop_word
            
            jsr std.print_u16_dec

            ;----------------------------------------------------- shift_left_w_num_u8

            lda #char.nl
            jsr sys.CHROUT

            load_imm_ay #123
            jsr stack.push_word

            lda #3
            jsr stack.push_byte
            
            jsr stack.shift_left_w_num_u8 ;   123 << 3(u8) = 984
            
            jsr stack.pop_word
            
            jsr std.print_u16_dec

            ;----------------------------------------------------- shift_right_num_u16

            lda #char.nl
            jsr sys.CHROUT

            load_imm_ay #984
            jsr stack.push_word

            load_imm_ay #3
            jsr stack.push_word
            
            jsr stack.shift_right_num_u16 ;   984 >> 3(u16) = 123
            
            jsr stack.pop_word
            
            jsr std.print_u16_dec
            
            ;---------------------------------------------------------------

            lda save_sp
            sta stack.pointer
            tax

            rts
            
    .pend

.pend

;;;
;;
;

