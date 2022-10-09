

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
    
    str1     .null   "1234.456"
    str2     .null   "-789.123"

    f1  .byte   0,0,0,0,0
    f2  .byte   0,0,0,0,0
    r   .byte   0,0,0,0,0
    
    ;
    
    start	.proc

        load_address_ay str1
        jsr float.copy_from_string  ;  

        load_address_ay f1
        jsr float.copy_fac1_to_mem

        load_address_ay str2
        jsr float.copy_from_string  ;  

        load_address_ay f2
        jsr float.copy_fac1_to_mem
        
        ;
        
        load_address_ay f1
        jsr float.print
        
        lda #char.nl
        jsr c64.CHROUT

        load_address_ay f2
        jsr float.print
        
        lda #char.nl
        jsr c64.CHROUT

        ;

        load_address_ay f1
        jsr basic.copy_mem_to_fac1

        load_address_ay f2
        jsr basic.copy_mem_to_fac2

        ;
        
        ;jsr  float.add      ;   445.333
        jsr  float.sub      ;   2023.579    -- = +
        ;jsr  float.mul      ;   -974137.622
        ;jsr  float.div      ;   -974137.622

        ;
        
        load_address_ay r
        jsr float.copy_fac1_to_mem
        
        lda #char.nl
        jsr c64.CHROUT
        
        load_address_ay r
        jsr float.print

        ;

        rts
    
    .pend

.pend

;;;
;;
;


