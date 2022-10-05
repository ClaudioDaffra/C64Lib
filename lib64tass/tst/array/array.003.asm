

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
 
                    ; 12
    arr1    .word   10,20,30,1,3,2,88,95,32768,27596,16382,45
    counter .byte   0
    arr2    .sint   -10,20,30,1,-3,2,88,-95,32767,-27596,16382,-45
    
    counter_max = 12*2
    
;--------------------------------------------------------------- main

main	.proc
 
    print_array_u16 .proc
    
        ldy #0
        sty counter
loop
        ldy counter
        
        lda (zpWord0),y
        pha
        
        iny
        lda (zpWord0),y
        pha
        
        iny
        sty counter

        pla
        tay
        pla
        jsr std.print_u16_dec
    
        lda #' '
        jsr sys.CHROUT

        ldy counter
        cpy #counter_max
        bne loop

        lda #char.nl
        jsr sys.CHROUT
        
        rts
        
    .pend

    print_array_s16 .proc
    
        ldy #0
        sty counter
loop
        ldy counter
        
        lda (zpWord0),y
        pha
        
        iny
        lda (zpWord0),y
        pha
        
        iny
        sty counter

        pla
        tay
        pla
        jsr std.print_s16_dec
    
        lda #' '
        jsr sys.CHROUT

        ldy counter
        cpy #counter_max
        bne loop

        lda #char.nl
        jsr sys.CHROUT
        
        rts
        
    .pend
    
    start	.proc

        ;   program
    
        ;   ----------------------------------------------------------- reverse_us16

        load_address_zpWord0 arr1
        jsr print_array_u16

                load_address_zpWord0 arr1
                lda #12
                jsr array.reverse_us16

        load_address_zpWord0 arr1
        jsr print_array_u16 


        ;   ----------------------------------------------------------- reverse_us16

        lda #char.nl
        jsr sys.CHROUT
        
        load_address_zpWord0 arr2
        jsr print_array_s16

                    load_address_zpWord0 arr2
                    lda #12
                    jsr array.reverse_us16

        load_address_zpWord0 arr2
        jsr print_array_s16
        
        rts
        
    .pend

.pend

;;;
;;
;
