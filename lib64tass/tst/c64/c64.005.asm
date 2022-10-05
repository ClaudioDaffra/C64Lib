

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
.include "../../lib/libMath.asm"
.include "../../lib/libSTDIO.asm"
.include "../../lib/libConv.asm"
.include "../../lib/libString.asm"

;--------------------------------------------------------------- sub

;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

main	.proc

    start	.proc

            ;   program
 
            ; .............................................. setup memory
 
            ;10 poke 56578,peek(56578) or 3
            ;lda 56578
            ;ora 3
            ;sta 56578
            
            jsr c64.setPortA_RW

            ;20 poke 56576,(peek(56576)and 252) or 1 : rem 32768        
            ; lda 56576
            ;and #252
            ; ora #1
            ;sta 56576
            
            lda #c64.bank2
            jsr c64.setBank
            
            ; 30 poke 53272,4
            ; 00001000
            ; 26 rem  bitmap      1   1  $2000
            ; 27 rem  screen  0000    0: $0000-$03FF, 0-1023.
            ;lda #4
            ;sta 53272

            lda #c64.bitmap1
            jsr c64.setBitmapOffset

            lda #c64.screen0
            jsr c64.setScreenOffset

            ;40 poke 648,128
            ; ( bank? + screen? / 256 )
            
            lda # (( c64.bank_addr2 + c64.screen_addr0 ) / 256 )
            ;lda #128
            sta c64.SCRPTR

            ; IMP !
            ;   ... TO USE routine txt,  for screen offset 0
            ;
            ;   64tass -D screen_addr = 0
            ;
            
            jsr sys.CLEARSCR
            
            lda #147
            jsr sys.CHROUT
            
            ;60 poke 32768,1 : rem scrive un carattere 'A'
            lda #1
            sta 32768
 
        rts
 

    .pend

.pend

;;;
;;
;

