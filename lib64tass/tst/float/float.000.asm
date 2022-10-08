

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

    
;--------------------------------------------------------------- sub

float .proc

    AYINT_facmo         = $64
    PI                  = 3.141592653589793
    TWOPI               = 6.283185307179586


    MOVFM       = $bba2
    FREADMEM    = $bba6
    CONUPK      = $ba8c
    FAREADMEM   = $ba90
    MOVFA       = $bbfc
    MOVAF       = $bc0c
    MOVEF       = $bc0f
    MOVMF       = $bbd4
    FTOSWORDYA  = $b1aa
    GETADR      = $b7f7
    QINT        = $bc9b
    AYINT       = $b1bf
    GIVAYF      = $b391
    FREADUY     = $b3a2
    FREADSA     = $bc3c
    FREADSTR    = $b7b5
    FPRINTLN    = $aabc
    FOUT        = $bddd
    FADDH       = $b849
    MUL10       = $bae2
    DIV10       = $bafe
    FCOMP       = $bc5b
    FADDT       = $b86a
    FADD        = $b867
    FSUBT       = $b853
    FSUB        = $b850
    FMULTT      = $ba2b
    FMULT       = $ba28
    FDIVT       = $bb12
    FDIV        = $bb0f
    FPWRT       = $bf7b
    FPWR        = $bf78
    FINLOG      = $bd7e
    NOTOP       = $aed4
    INT         = $bccc
    LOG         = $b9ea
    SGN         = $bc39
    SIGN        = $bc2b
    ABS         = $bc58
    SQR         = $bf71
    SQRA        = $bf74
    EXP         = $bfed
    NEGOP       = $bfb4
    RND         = $e097
    COS         = $e264
    SIN         = $e26b
    TAN         = $e2b4
    ATN         = $e30e
    
    ;   .................................................... print
    ;
    ;   input   :   ay  address (float)
    ;
    print   .proc

            stx  zpx

            jsr  float.MOVFM        ; load float into fac1
            jsr  float.FOUT         ; fac1 to string in A/Y
            sta  zpWord0
            sty  zpWord0+1
            ldy  #0
        -
            lda  (zpWord0),y
            beq  +
            jsr  c64.CHROUT
            iny
            bne  -
        +
            ldx  zpx
            
            rts
        
        .pend

.pend

;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

;   float 5

float_123_456   .byte  $87, $76, $e9, $78, $d4  ; float_123.456
float_456_123   .byte  $89, $64, $0f, $be, $76  ; float_456.123
float_0_789     .byte  $80, $49, $fb, $e7, $6c  ; float_0.789
float_789_123   .byte  $8a, $45, $47, $df, $3b  ; float_789.123

; float 4

;--------------------------------------------------------------- main

main	.proc

    fvar1 = float_123_456
    
    str     .null   "1234.456"
    fvar2   .byte   0,0,0,0,0,0
    fvar3   .byte   0,0,0,0,0
    
    start	.proc

        jsr basic.txtptr.push   ;   basic_txtptr_push
        
        ;
        
        load_address_ay str
        jsr basic.txtptr.set
        
        jsr basic.get_char
        
        jsr basic.get_float_from_string

            load_address_xy fvar3
            jsr basic.round_fac1_to_mem 

        load_address_xy fvar2
        jsr basic.copy_fac1_to_mem  ;    copy_fac1_to_mem

        ;
        
        load_address_ay fvar2
        jsr float.print
        
        ;   

        load_address_ay fvar3
        jsr float.print
        ;
        
        jsr basic.txtptr.pop        ;   basic_txtptr_pop
        
        rts
    
    .pend

.pend

;;;
;;
;

