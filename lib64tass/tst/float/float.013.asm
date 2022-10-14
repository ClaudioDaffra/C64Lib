

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

;--------------------------------------------------------------- main
        
main	.proc

    str1     .null   " 1234.456"
    str2     .null   " 789.321" 

    f1  .byte   0,0,0,0,0
    f2  .byte   0,0,0,0,0
    r   .byte   0,0,0,0,0
    
    ;
    
    start   .proc

        .load_address_ay str1
        jsr float.copy_from_string

        .load_address_ay f1
        jsr float.copy_fac1_to_mem
 
        .load_address_ay f1
        jsr float.print

        lda #char.nl
        jsr c64.CHROUT
        
        .load_address_ay str2
        jsr float.copy_from_string

        .load_address_ay f2
        jsr float.copy_fac1_to_mem
 
        .load_address_ay f2
        jsr float.print

        lda #char.nl
        jsr c64.CHROUT

        ;   .......................... fac2 , fac1 !
        
        .load_address_ay f1
        jsr float.copy_mem_to_fac1
        
        .load_address_ay f2

        ;   .......................... 

        ;   jsr float.ay.add       ;   fac2+fac1
        ;   jsr float.ay.sub       ;   fac2-fac1
        ;  jsr float.ay.mul        ;   fac2*fac1
           jsr float.ay.div        ;   fac1/fac2
        
        ;   ..........................
        
        .load_address_ay f1
        jsr float.copy_fac1_to_mem

        ;
        
        .load_address_ay f1
        jsr float.print
        
        lda #char.nl
        jsr c64.CHROUT
 

        ;

        rts

    .pend

.pend

;;;
;;
;


