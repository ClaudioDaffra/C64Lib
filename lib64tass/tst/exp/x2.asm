

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
    varf
    ;.byte  $85, $17, $33, $33, $33
    
    .byte $85, $cf ,$4 ,$cc ,$cd
    ; float prog8.code.StArrayElement@7b50df34

;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

 
    
main	.proc

    start	.proc
    load_address_ay         varf
    jsr float.print
    rts
    
    .pend

.pend

;;;
;;
;

