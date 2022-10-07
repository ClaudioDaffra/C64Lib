

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

    callback    .proc
    
        lda 1024
        clc
        adc #1
        sta 1024
        
        rts
        
    .pend

;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

main	.proc

    start	.proc

        load_address_ay callback
        clc
        jsr irq.set_raster
        
        jsr c64.CHRIN   ;   char + return
        
        jsr irq.restore
        
        rts
    
    .pend

.pend

;;;
;;
;

