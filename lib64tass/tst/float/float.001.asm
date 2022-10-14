

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

    fvar4   .byte   0,0,0,0,0,0
    
    start   .proc


        .load_address_ay str
        jsr float.copy_from_string  ;   load string in fac1
        
        .load_address_ay fvar2
        jsr float.copy_fac1_to_mem  ;   copy_fac1_to_mem

        .load_address_ay fvar2       ;   print string
        jsr float.print

        ;

        .load_address_ay fvar2       ;   load var in fac1
        jsr float.copy_fac1_from_mem

        .load_address_ay fvar3       ;   round from fac1 to mem
        jsr float.round_fac1_to_mem 

        .load_address_ay fvar3       ;   print string
        jsr float.print
        
        ;

        .load_address_ay fvar2       ;   load var in fac1
        jsr float.copy_fac1_from_mem
        
        jsr float.copy_fac1_to_fac2
        
        jsr float.copy_fac2_to_fac1
        
        .load_address_ay fvar4
        jsr float.copy_fac1_to_mem  ;   copy_fac1_to_mem
        
        .load_address_ay fvar4       ;   print string
        jsr float.print
        
        ;

        rts
    
    .pend

.pend

;;;
;;
;

