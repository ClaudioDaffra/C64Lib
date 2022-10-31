

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
 
    
;--------------------------------------------------------------- global


    arrb     .fill   2000 ;

;--------------------------------------------------------------- main

main	.proc

    print_index .proc

        lda #' '
        jsr c64.CHROUT
        
        load_var_ay zpWord0
        jsr txt.print_u16_dec

        lda #char.nl
        jsr c64.CHROUT
        
        rts
        
    .pend
    
    start	.proc

        ;   ................................................... array.small.size

        load_address_ay         arrb
        jsr txt.print_u16_dec
        
        ;
        
        lda #4  ;   size
        sta array.small.size
    
        load_address_zpWord0    arrb

        ldx #255  ;   index
        
        jsr array.small.dim1
        
        jsr print_index
 

        ;   ................................................... array.small.size

        .load_address_ay         arrb
        jsr txt.print_u16_dec
        
        ;
        
        lda #4                  ;   size
        sta array.small.size
        lda #25                 ;   maxy
        sta array.small.maxy
    
        .load_address_zpWord0    arrb    ;   array
        ldx #12                          ;   index x
        ldy #10                          ;   index y
        jsr array.small.dim2
        
        jsr print_index

        rts
        
    .pend

.pend

;;;
;;
;
