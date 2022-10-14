

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
 

    arr1    .byte   10,20,30
 
    counter_max = 3
    
;--------------------------------------------------------------- main

main	.proc
 
    counter .byte   0
    print_array_u8 .proc
    
        ldy #0
        sty counter
loop
        ldy counter
        
        lda (zpWord0),y

        iny
        sty counter

        sec
        jsr std.print_u8_bin
    
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
    
        ;   ----------------------------------------------------------- ror/rol ub

        lda #char.nl
        jsr c64.CHROUT
        
        .load_address_zpWord0 arr1
        jsr print_array_u8

                .load_address_zpWord0 arr1
                
                ldy #2
                
                jsr array.rol_ub
                ;jsr array.ror_ub
                ;jsr array.rol2_ub
                ;jsr array.ror2_ub
                
        .load_address_zpWord0 arr1
        jsr print_array_u8 


        ;   ----------------------------------------------------------- 
 
        rts
        
    .pend

.pend

;;;
;;
;
