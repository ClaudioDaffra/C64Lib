

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

;--------------------------------------------------------------- sub

.comment

    dim1  :=       (x) * size
    dim2  :=  ((   (x) * maxy ) + y )* size
    dim3  :=  (((( (z) * maxz ) * maxy ) + y ) * maxz +x ) * size

.endc

;  ............................................. calc index array
;
;  input   :   x y z   maxx , maxy , maxz , size
;  output  :   zpWord0
;

array_fast  .proc
        
        mul1    .proc
            jmp array_fast_ret
        .pend
        mul2    .proc
            asl
            sta zpa
            jmp  array_fast_ret
        .pend
        mul4    .proc
            asl
            asl
            sta zpa
            jmp array_fast_ret
        .pend
        mul5    .proc
            sta zpa
            asl
            asl
            clc
            adc zpa
            sta zpa
            jmp  array_fast_ret
        .pend
        
        ;   ..................................................... dim1
        dim1  .proc
                size1   .proc
                    txa     ;   mul by 1
                    jmp mul1
                .pend
                size2   .proc
                    txa     ;   mul by 2
                    jmp mul2
                .pend
                size4   .proc
                    txa     ;   mul by 4
                    jmp mul4
                .pend
                size5   .proc
                    txa ;   mul by 5
                    jmp mul5
                .pend
                sizex   .proc
                    txa ;   mul by size a*y -> a
                    ldy size
                    jsr math.mul_u8
                    jmp  array_fast_ret
                .pend
        .pend
        ;   ..................................................... dim2
        dim2  .proc
                cndx2   .proc
                    sta dim2_maxy
                    stx dim2_x
                    sty dim2_y
                    
                    lda dim2_x
                    ldy dim2_maxy 

                    jsr math.mul_u8
                    clc
                    adc dim2_y
                    rts
                .pend
                size1   .proc
                    jsr cndx2
                    jmp array_fast_ret
                .pend
                size2   .proc
                    jsr cndx2
                    jmp mul2
                .pend
                size4   .proc
                    jsr cndx2
                    jmp mul4
                .pend
                size5   .proc
                    jsr cndx2
                    jmp mul5
                .pend
                sizex   .proc
                    jsr cndx2   ; a
                    ldy size    ; y
                    jsr math.mul_u8 ; a*y
                    jmp  array_fast_ret
                .pend
                dim2_x      .byte 0
                dim2_y      .byte 0
                dim2_maxy   .byte 0
        .pend
                
        array_fast_ret
            sta zpa
            jsr math.zpWord0_add_zpa
            rts
    size    .byte   0
.pend

;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

    xy       .byte   1
    arrb     .fill   256;
    xx       .byte   1
;
 
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

        ;   ................................................... array_fast.dim1.size1
        
        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4
        jsr array_fast.dim1.size1
        
        jsr  print_index
        
        ;   ................................................... array_fast.dim1.size2
        
        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb

        jsr array_fast.dim1.size2
        
        jsr  print_index
        
        ;   ................................................... array_fast.dim1.size4
        
        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4
        jsr array_fast.dim1.size4
        
        jsr  print_index
        
        ;   ................................................... array_fast.dim1.size5
        
        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4
        jsr array_fast.dim1.size5
        
        jsr  print_index
        
        ;   ................................................... array_fast.dim1.sizex
        
        load_address_ay         arrb
        jsr txt.print_u16_dec

        lda #7
        sta array_fast.size
        load_address_zpWord0    arrb
        ldx #4
        jsr array_fast.dim1.sizex
        
        jsr  print_index

        ;   ...................................................
        
        lda #char.nl
        jsr c64.CHROUT

        ;   ................................................... array_fast.dim2.size1
;43
        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4  ;   x
        ldy #3  ;   y
        lda #10 ;   max y
        jsr array_fast.dim2.size1
        
        jsr  print_index

        ;   ................................................... array_fast.dim2.size2

        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4  ;   x
        ldy #3  ;   y
        lda #10 ;   max y
        jsr array_fast.dim2.size2
        
        jsr  print_index

        ;   ................................................... array_fast.dim2.size4

        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4  ;   x
        ldy #3  ;   y
        lda #10 ;   max y
        jsr array_fast.dim2.size4
        
        jsr  print_index

        ;   ................................................... array_fast.dim2.size5

        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        ldx #4  ;   x
        ldy #3  ;   y
        lda #10 ;   max y
        jsr array_fast.dim2.size5
        
        jsr  print_index

        ;   ................................................... array_fast.dim2.sizex

        load_address_ay         arrb
        jsr txt.print_u16_dec

        load_address_zpWord0    arrb
        lda #5
        sta array_fast.size
        ldx #4  ;   x
        ldy #3  ;   y
        lda #10 ;   max y
        jsr array_fast.dim2.sizex
        
        jsr  print_index


        rts
        
    .pend

.pend

;;;
;;
;

