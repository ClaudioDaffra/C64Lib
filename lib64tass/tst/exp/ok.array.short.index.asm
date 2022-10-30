

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

 
;  ............................................. calc index array
;
;  input   :   x y z   maxx , maxy , maxz , size
;  output  :   zpWord
;

array_short  .proc
        ;  ................................................................. index 1   :   x*size
        index1  .proc
                ; a*y=ay
                txa
                ldy size
                jsr math.mul_bytes_into_u16
                sta zpWord1+0
                sty zpWord1+1
                jsr math.zpWord0_add_zpWord1
                rts
        .pend
                
        ;  ................................................................. index 2   :   x*size
        index2  .proc

 
                rts
        .pend
                
        ;maxx    .byte   0
        ;maxy    .byte   0
        ;maxz    .byte   0
        size    .byte   0

.pend

    
;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

    xy       .byte   1
    arrb     .fill   1000;
    xx       .byte   1
;
        print_array_address .proc
            load_address_ay         arrb
            jsr txt.print_u16_dec
            
            rts
        .pend

        print_array_index .proc
            lda #' '
            jsr c64.CHROUT
            
            load_var_ay zpWord2
            jsr txt.print_u16_dec

            lda #char.nl
            jsr c64.CHROUT
            
            rts
        .pend
        
main	.proc

    start	.proc

        ;   ................................................... array_shortindex1.size

        jsr print_array_address
        
        lda #4  ;   size
        sta array_short.size
    
        load_address_zpWord0    arrb

        ldx #255  ;   index
        
        jsr array_short.index1
        
        jsr print_array_index
 
        rts

    .pend

.pend

;;;
;;
;

