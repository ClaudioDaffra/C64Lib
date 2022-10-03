

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

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

main	.proc

    start	.proc

            ;   program
 
            lda #' '
            ldy #color.green
            jsr txt.fill_screen

            ; .............................................. store
 
            jsr sys.istop
            jsr std.print_u8_dec
            
            lda #char.nl
            jsr sys.CHROUT
            
            jsr sys.RDTIM16
            jsr std.print_u8_bin
            
            rts
 

    .pend

.pend

;;;
;;
;

