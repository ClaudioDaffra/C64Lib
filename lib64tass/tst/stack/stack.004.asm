

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

    print_pop_uword .proc
    
            lda #char.nl
            jsr sys.CHROUT
            
            jsr stack.pop_word
            
            jsr txt.print_u16_hex
            
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

            ;---------------------------------------------------------------  stack mul byte

            lda #char.nl
            jsr sys.CHROUT
            
            lda #13
            jsr stack.push_byte
            
            jsr stack.mul_byte_3  ;   13*3 = 39
            
            jsr stack.pop_byte
            
            jsr std.print_u8_dec
            
            ;---------------------------------------------------------------   stack mul word

            lda #char.nl
            jsr sys.CHROUT
            
            load_imm_ay #1234
            
            jsr stack.push_word
            
            jsr stack.mul_word_3  ;
            
            jsr stack.pop_word
            
            jsr std.print_u16_dec

            ;---------------------------------------------------------------  stack mul byte

            lda #char.nl
            jsr sys.CHROUT
            
            lda #2
            jsr stack.push_byte
            
            jsr stack.mul_byte_40  ; 
            
            jsr stack.pop_byte
            
            jsr std.print_u8_dec
            
            ;---------------------------------------------------------------  stack mul byte

            lda #char.nl
            jsr sys.CHROUT
            
            lda #2
            jsr stack.push_byte
            
            jsr stack.mul_byte_50  ; 
            
            jsr stack.pop_byte
            
            jsr std.print_u8_dec
            
            ;---------------------------------------------------------------  stack mul byte

            lda #char.nl
            jsr sys.CHROUT
            
            lda #3
            jsr stack.push_byte
            
            jsr stack.mul_byte_80  ; 
            
            jsr stack.pop_byte
            
            jsr std.print_u8_dec

            ;---------------------------------------------------------------
            
            lda #char.nl
            jsr sys.CHROUT
            
            lda #2
            jsr stack.push_byte
            
            jsr stack.mul_byte_100  ; 
            
            jsr stack.pop_byte
            
            jsr std.print_u8_dec

            ;---------------------------------------------------------------   stack mul word

            lda #char.nl
            jsr sys.CHROUT
            
            load_imm_ay #12
            
            jsr stack.push_word
            
            jsr stack.mul_word_640  ;
            
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

