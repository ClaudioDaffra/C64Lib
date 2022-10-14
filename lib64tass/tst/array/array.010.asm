

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

    ;   float[] arrayFloat = [   1.2  , -3.4   , 5.6   , -7.8    , 9.1    ,
    ;                           10.3  ,-11.4   ,12.5   ,-16.6    ,18.9    ] ;
        
    arrayFloat

    .byte  $81, $19, $99, $99, $99  ; float prog8.code.StArrayElement@51bf5add
    .byte  $82, $d9, $99, $99, $99  ; float prog8.code.StArrayElement@7905a0b8
    .byte  $83, $33, $33, $33, $33  ; float prog8.code.StArrayElement@35a3d49f
    .byte  $83, $f9, $99, $99, $99  ; float prog8.code.StArrayElement@389b0789
    .byte  $84, $11, $99, $99, $99  ; float prog8.code.StArrayElement@13d9cbf5
    .byte  $84, $24, $cc, $cc, $cc  ; float prog8.code.StArrayElement@478db956
    .byte  $84, $b6, $66, $66, $66  ; float prog8.code.StArrayElement@6ca18a14
    .byte  $84, $48, $00, $00, $00  ; float prog8.code.StArrayElement@c667f46
    .byte  $85, $84, $cc, $cc, $cc  ; float prog8.code.StArrayElement@51bd8b5c
    .byte  $85, $17, $33, $33, $33  ; float prog8.code.StArrayElement@7b50df34

    varf    
    
    .byte   $85, $17, $33, $33, $33 ;   18.9
    
;--------------------------------------------------------------- main



    
;--------------------------------------------------------------- main

main	.proc

    start	.proc

        ;   program

        ;                                   arraFloat[1] := 0
        .load_address_zpWord0    arrayFloat
        ldx #1
        
        ;
        
        jsr float.set0_array
        
        ;
        
        
        .load_address_ay         arrayFloat
        ldx #10                              ;   0-9 (10 elements)
        jsr float.print_array
        
        rts
        
    .pend

.pend


;;;
;;
;
