

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

    str1     .null   "123.456"
    str2     .null   "-456.321"
    str3     .null   "456.789"
    str4     .null   "-23.456"
    ;

    start	.proc

        ;
        
        ;   ........................................ float.cast_fac1_to_u16
        ;   "123.456"   ->  123
        lda #char.nl
        jsr c64.CHROUT
        
        .load_address_ay str1
        jsr float.copy_from_string

        jsr float.cast_fac1_to_u16
        
        jsr std.print_u16_dec
        
        ;   ........................................ float.cast_fac1_to_s16
        ;   "-456.321"  -457
        lda #char.nl
        jsr c64.CHROUT
        
        .load_address_ay str2
        jsr float.copy_from_string

        jsr float.cast_fac1_to_s16
        
        jsr std.print_s16_dec

        ;   ........................................ float.cast_fac1_to_u8
        ;   456 1c8 (byte)  c8  (200)
        lda #char.nl
        jsr c64.CHROUT
        
        .load_address_ay str3
        jsr float.copy_from_string

        jsr float.cast_fac1_to_u8
        
        jsr std.print_u8_dec
        
        ;   ........................................ float.cast_fac1_to_s8
        ;   "-23.456"   24
        lda #char.nl
        jsr c64.CHROUT
        
        .load_address_ay str4
        jsr float.copy_from_string

        jsr float.cast_fac1_to_s8

        jsr std.print_s8_dec

        rts
    
    .pend

.pend

;;;
;;
;

