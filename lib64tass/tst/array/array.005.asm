

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
    arr1    .word   10,20,30 
    counter .byte   0
 
    
    counter_max = 2*2
    
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
        
        sec
        jsr std.print_u16_bin
    
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
    
        ;   ----------------------------------------------------------- rol/ror uw

        load_address_zpWord0 arr1
        jsr print_array_u16
 
                load_address_zpWord0 arr1
                ldy #1
                jsr array.ror_uw
                ;jsr array.ror_uw
                ;jsr array.ror2_uw
                ;jsr array.ror2_uw
                
        load_address_zpWord0 arr1
        jsr print_array_u16 

 
        rts
        
    .pend

.pend

;;;
;;
;
