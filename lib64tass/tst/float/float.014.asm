

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

;--------------------------------------------------------------- define

;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- lib


    f1      .byte   $8b , $9a , $40 , $17   ; -1234.0028
    
    f2      .byte   $82 , $00 , $01 , $a3   ;     2.0001
    
    af4     .byte   $82 , $00 , $01 , $a3   ;     2.0001
            .byte   $8b , $9a , $40 , $17   ;     -1234.0028
            .byte   $8b , $1a , $4e , $98   ;     1234.46
            .byte   $82 , $00 , $01 , $a3   ;     2.0001
            .byte   $8b , $9a , $40 , $17   ;     -1234.0028
            .byte   $8b , $1a , $4e , $98   ;     1234.46
            
;--------------------------------------------------------------- main
        
main	.proc

    start   .proc

        load_address_ay f1
        jsr float4.copy_mem_to_fac1

        .load_address_ay zpWord2
        jsr float.print

        lda #char.nl
        jsr c64.CHROUT
        
        ;

        load_address_ay f2
        jsr float4.copy_mem_to_fac1

        .load_address_ay zpWord2
        jsr float.print
        
        lda #char.nl
        jsr c64.CHROUT
        
        ;

        load_address_ay zpWord2
        jsr float4.copy_fac1_to_mem

        load_address_ay f2
        jsr float4.copy_mem_to_fac1
        
        .load_address_ay zpWord2
        jsr float.print
        
        lda #char.nl
        jsr c64.CHROUT
        

        ;
        
        .load_address_ay af4
        ldx #2
        jsr float4.calc_index
        
        .load_address_ay zpWord2
        jsr float.print
        
        rts

    .pend

.pend

;;;
;;
;


