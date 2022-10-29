

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
    varf
    ;.byte  $85, $17, $33, $33, $33
    
    .byte $85, $cf ,$4 ,$cc ,0   ; l_float 4
    

;--------------------------------------------------------------- program


        sign   .byte   $ea      ;
        x2     .byte   $ea      ;         exponent 2
        m2     .byte   0,0,0    ;         mantissa 2
        x1     .byte   $ea      ;         exponent 1
        m1     .byte   0,0,0    ;         mantissa 1
        e      .byte   0,0,0,0  ;         scratch
        z      .byte   0,0,0,0  ;
        t      .byte   0,0,0,0  ;
        sexp   .byte   0,0,0,0  ;
        int    .byte   1        ;


    ;   CONVERT 16 BIT INTEGER IN M1(HIGH) AND M1+1(LOW) TO F.P.
    ;   RESULT IN EXP/MANT1.  EXP/MANT2 UNEFFECTED

          conv_word_to_fac4
                
        l_float  
            lda #$8e
            sta x1       ;   set expn to 14 dec
            lda #0       ;   clear low order byte
            sta m1+2
            beq norm     ;   normalize result
        norm1  
            dec x1       ;   decrement exp1
            asl m1+2
            rol m1+1     ;   shift mant1 (3 bytes) left
            rol m1
        norm   
            lda m1       ;   high order mant1 byte
            asl          ;   upper two bits unequal?
            eor m1
            bmi rts1    ;    yes,return with mant1 normalized
            lda x1      ;    exp1 zero?
            bne norm1   ;    no, continue normalizing
        rts1   
            rts         ;    return

;--------------------------------------------------------------- lib

program .proc

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

 
    
main	.proc

    var .word 49152
    f4  .byte 0,0,0,0,0
    
    start	.proc
 
        lda #<var
        sta m1
        lda #>var
        sta m1+1
        
        jsr conv_word_to_fac4
        
        lda x1
            sta f4+1
        lda m1+0
            sta f4+0
        lda m1+1
            sta f4+2
        lda m1+2
            sta f4+3
        lda #0
            sta f4+4
 
        .load_address_ay f4
        jsr float.print
            
        rts
    
    .pend

.pend

;;;
;;
;

