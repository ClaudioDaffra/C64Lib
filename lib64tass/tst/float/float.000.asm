

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

;--------------------------------------------------------------- define

;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

;   float 5

float_123_456   .byte  $87, $76, $e9, $78, $d4  ; float_123.456
float_456_123   .byte  $89, $64, $0f, $be, $76  ; float_456.123
float_0_789     .byte  $80, $49, $fb, $e7, $6c  ; float_0.789
float_789_123   .byte  $8a, $45, $47, $df, $3b  ; float_789.123

; float 4

;--------------------------------------------------------------- main

main	.proc

    fvar1 = float_123_456
    
    str     .null   "1234.456"
    fvar2   .byte   0,0,0,0,0,0
    fvar3   .byte   0,0,0,0,0
    
    start	.proc

        jsr basic.txtptr.push           ;   basic_txtptr_push
        
        ;
        
        load_address_ay str
        jsr basic.txtptr.set
        
        jsr basic.get_char
        
        jsr basic.get_float_from_string

        load_address_xy fvar3           ;   xy
        jsr basic.round_fac1_to_mem     ;   round_fac1_to_mem

        load_address_xy fvar2           ;   xy
        jsr basic.copy_fac1_to_mem      ;   copy_fac1_to_mem

        ;
        
        load_address_ay fvar2
        jsr float.print

        load_address_ay fvar3
        jsr float.print

        ;
        
        jsr basic.txtptr.pop        ;   basic_txtptr_pop
        
        ;

        rts
    
    .pend

.pend

;;;
;;
;

