

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

    xy       .byte   1
    arrb     .fill   256;
    xx       .byte   1

    
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

        ;   ................................................... array.short.dim1.size1
        
        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4
        jsr array.short.dim1.size1
        
        jsr  print_index
        
        ;   ................................................... array.short.dim1.size2
        
        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb

        jsr array.short.dim1.size2
        
        jsr  print_index
        
        ;   ................................................... array.short.dim1.size4
        
        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4
        jsr array.short.dim1.size4
        
        jsr  print_index
        
        ;   ................................................... array.short.dim1.size5
        
        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4
        jsr array.short.dim1.size5
        
        jsr  print_index
        
        ;   ................................................... array.short.dim1.sizex
        
        load_address_ay         arrb
        jsr txt.print_u16_dec

        lda #7
        sta array.short.size
        load_address_zpWord0    arrb
        ldx #4
        jsr array.short.dim1.sizex
        
        jsr  print_index

        ;   ...................................................
        
        lda #char.nl
        jsr c64.CHROUT

        ;   ................................................... array.short.dim2.size1
;43
        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4  ;   x
        ldy #3  ;   y
        lda #10 ;   max y
        jsr array.short.dim2.size1
        
        jsr  print_index

        ;   ................................................... array.short.dim2.size2

        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4  ;   x
        ldy #3  ;   y
        lda #10 ;   max y
        jsr array.short.dim2.size2
        
        jsr  print_index

        ;   ................................................... array.short.dim2.size4

        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4  ;   x
        ldy #3  ;   y
        lda #10 ;   max y
        jsr array.short.dim2.size4
        
        jsr  print_index

        ;   ................................................... array.short.dim2.size5

        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4  ;   x
        ldy #3  ;   y
        lda #10 ;   max y
        jsr array.short.dim2.size5
        
        jsr  print_index

        ;   ................................................... array.short.dim2.sizex

        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        lda #5
        sta array.short.size
        ldx #4  ;   x
        ldy #3  ;   y
        lda #10 ;   max y
        jsr array.short.dim2.sizex
        
        jsr  print_index


        rts
        
    .pend

.pend

;;;
;;
;
