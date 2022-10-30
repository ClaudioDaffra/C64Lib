

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

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

              ;76543210
    v1  .byte %01011010
    v2  .byte %10100101
    
    extract .macro 
        .rept (\2)-\1
        ror
        .endrept

   .endm

    
    
main	.proc

    start	.proc
    
              ; 765.432.10
              ;%010.110.10 
    v1  .byte %01011010

        lda v1  ;   432

        ;lsr
        ;lsr
        .extract 2,4
        ;and #%00000111

        jsr txt.print_u8_bin
        
        rts
    
    .pend

.pend

;;;
;;
;

