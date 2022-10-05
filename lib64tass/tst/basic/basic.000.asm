

.cpu  '6502'
.enc  'none'

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

;--------------------------------------------------------------- macro

    forb    .macro 
            \1
            lda \2
            adc \5 
            sta \2
    .endmacro
    
    nextb    .macro
    
    .endmacro
    
;--------------------------------------------------------------- main

main	.proc

    i       .byte    0
    maxi    .byte   10
    stepi   .byte    1
    
    start	.proc

        ;   program

        lda #' '
        ldy #color.green
        jsr txt.fill_screen


        loop
        lda i
        adc stepi 
        sta i

            lda #'*'
            jsr sys.CHROUT

        lda i
        cmp maxi
        bne loop

        rts
 

    .pend

.pend

;;;
;;
;
