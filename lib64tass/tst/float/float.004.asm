

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
    fvar2    .byte   0,0,0,0,0,0

    ubyte   .byte         123
    sbyte   .char        -123
    uword   .word       53632
    sword   .sint      -24534

    fvar_pop    .byte   0,0,0,0,0,0
    
    ;
    
    start	.proc

        ;
        
        ;   ........................................    ubyte   123

        lda #char.nl
        jsr c64.CHROUT
        
        lda ubyte
        jsr float.conv_u8_to_fac1
    
        .load_address_ay fvar2
        jsr float.copy_fac1_to_mem

        .load_address_ay fvar2
        jsr float.print

        ;   ........................................    sbyte -123

        lda #char.nl
        jsr c64.CHROUT
        
        lda sbyte
        jsr float.conv_s8_to_fac1
    
        .load_address_ay fvar2
        jsr float.copy_fac1_to_mem

        .load_address_ay fvar2
        jsr float.print

        ;   ........................................    uword 53632
        
        lda #char.nl
        jsr c64.CHROUT
        
        .load_var_ay     uword 
        jsr float.conv_u16_to_fac1
    
        .load_address_ay fvar2
        jsr float.copy_fac1_to_mem

        .load_address_ay fvar2
        jsr float.print

        ;   ........................................    word -24534
        
        lda #char.nl
        jsr c64.CHROUT
        
        .load_var_ay     sword 
        jsr float.conv_s16_to_fac1
    
        .load_address_ay fvar2
        jsr float.copy_fac1_to_mem

        .load_address_ay fvar2
        jsr float.print

        ;   ........................................    push pop mem
        
        lda #char.nl
        jsr c64.CHROUT
        
        .load_address_ay fvar2
        jsr float.push_mem

        .load_address_ay fvar_pop
        jsr float.pop_mem
        
        .load_address_ay fvar_pop
        jsr float.print
        
        ;

        rts
    
    .pend

.pend

;;;
;;
;

