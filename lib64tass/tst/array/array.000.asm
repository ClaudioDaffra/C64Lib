

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
 
                    ; 20
    arr1    .byte   1,7,255,2,5,33,6,4,3,9,0,3,32,128,17,26,35,35,80,192            ;   OK
    counter .byte   0
    arr2    .char   1,-7,127,2,-5,-33,6,4,-3,-9,0,3,32,-127,17,26,35,35,-80,19      ;   KO
    
    counter_max = 20 
    
;--------------------------------------------------------------- main

main	.proc
 
    print_array_u8 .proc
    
        ldy #0
        sty counter
loop
        ldy counter
        
        lda (zpWord0),y

        iny
        sty counter

        jsr std.print_u8_dec
    
        lda #' '
        jsr c64.CHROUT

        ldy counter
        cpy #counter_max
        bne loop

        lda #char.nl
        jsr c64.CHROUT
        
        rts
        
    .pend
    print_array_s8 .proc
    
        ldy #0
        sty counter
loop
        ldy counter
        
        lda (zpWord0),y

        iny
        sty counter

        jsr std.print_s8_dec
    
        lda #' '
        jsr c64.CHROUT

        ldy counter
        cpy #counter_max
        bne loop

        lda #char.nl
        jsr c64.CHROUT
        
        rts
        
    .pend
    start	.proc

        ;   program
    
        ;   ----------------------------------------------------------- sort_u8

        load_address_zpWord0 arr1
        jsr print_array_u8
 
        load_address_zpWord0 arr1
        lda #counter_max
        jsr array.sort_u8

        load_address_zpWord0 arr1
        jsr print_array_u8
 
        ;   ----------------------------------------------------------- sort_s8

        lda #char.nl
        jsr c64.CHROUT
        
        load_address_zpWord0 arr2
        jsr print_array_s8

        load_address_zpWord0 arr2
        lda #counter_max
        jsr array.sort_s8

        load_address_zpWord0 arr2
        jsr print_array_s8


        rts
        
    .pend

.pend

;;;
;;
;
