

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
 
    arr1    .byte   1,2,3,4,5,6,8,9,10
    arr2    .word   1,2,3,4,5,6,8,9,10
    
;--------------------------------------------------------------- main

main	.proc

    start	.proc

        ;   program
 
        ;..................................................... containment_byte
        
        load_address_zpWord0    arr1 
        lda #4
        ldy #10
        jsr array.containment_byte
        
        sta 1024    ;   or carry    a=1=true

        load_address_zpWord0    arr1
        lda #15
        ldy #10
        jsr array.containment_byte
        
        sta 1025    ;   or carry    @=0=false

        ;..................................................... containment_word
        
        load_address_zpWord0    arr2
        load_imm_zpWord1        #03
        ldy #10
        jsr array.containment_word
        
        sta 1026    ;   or carry    a=1=true

        load_address_zpWord0    arr2
        load_imm_zpWord1        #15
        ldy #10
        jsr array.containment_word
        
        sta 1027    ;   or carry    a=1=true
        
        rts
        
    .pend

.pend

;;;
;;
;
