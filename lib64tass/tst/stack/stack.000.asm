

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

    start	.proc

            ;   program
 
            ;--------------------------------------------------------------- clear
 
            lda #' '
            ldy #color.green
            jsr txt.fill_screen
 
            ;--------------------------------------------------------------- push / pop

            jsr debug_stack

            lda #1
            jsr stack.push_byte
            lda #2
            jsr stack.push_byte
            lda #3
            jsr stack.push_byte
            
                jsr debug_stack

            lda #char.nl
            jsr sys.CHROUT
            
            jsr stack.pop_byte
            jsr std.print_u8_dec
            
            lda #char.nl
            jsr sys.CHROUT
            
            jsr stack.pop_byte
            jsr std.print_u8_dec
            
            lda #char.nl
            jsr sys.CHROUT

            jsr stack.pop_byte
            jsr std.print_u8_dec
            
            lda #char.nl
            jsr sys.CHROUT

                jsr debug_stack

            ;--------------------------------------------------------------- 

            ;  [$ff][$fc]
            ;  3
            ;  2
            ;  1
            ;  [$ff]
            
            rts
            

    .pend

.pend

;;;
;;
;

