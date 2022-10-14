

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

    timer   .proc
        
        TALO    =   $DD04
        TAHI    =   $DD05
        CTLO    =   $DD06
        CTHI    =   $DD07
        ICR     =   $DD0D
        CRA     =   $DD0E
        CRB     =   $DD0F
        RASTHI  =   $D011
        RASTLO  =   $D012
        VICIRQ  =   $D019
        SCNKEY  =   $FF9F

            init    .proc

                    lda #$7f
                    ldx #$fe
                    ldy #$03
                    sta ICR
                    stx TALO
                    sty TAHI
             CNTSET
                    lda #$FF
                    sta CTLO
                    sta CTHI
                    ldy #$51
                    sty CRB
                    rts
                    
            .pend

            start    .proc
            
                    sta CB+1
                    sty CB+2

                    lda #$00
                    sta CRA
                    lda CTLO
                    eor #$FF
                    sta LATEN
                    lda CTHI
                    sta LATEN+1

                    sei
                    lda #$01
                    sta VICIRQ
                    lda RASTHI
                    and #$7f
                    sta RASTHI
               scan
                    lda VICIRQ
                    and #$01
                    beq scan
                    lda RASTHI
                    ora #$10
                    sta RASTHI
                    
                    ldx #$11
                    sta CRA

                 CB
                    jsr $1971   ;   callback

                    ;jmp CB
                    
                    rts
                    
            .pend

            stop    .proc
            
                    .load_address_ay timer.stop
                    sta timer.start.CB+1
                    sty timer.start.CB+2
                    
                    lda #$00
                    sta CRA
                    lda CTLO
                    eor #$FF
                    sta LATEN
                    lda CTHI
                    sta LATEN+1
                    cli
                    clv
                    bvc timer.init.CNTSET
                    
                    rts
                    
            .pend
         LATEN .word 0
         
    .pend

;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

main	.proc

    print_num   .proc
    

                ldy #255
            loop2           
                ldx #255
            loop           
                lda 1044
                clc
                adc #1
                sta 1044

                dex
                bne loop
                dey
                bne loop2
            
            rts
            
    .pend
    
    print_timer .proc
    
            .load_imm_ay #$DD04
            jsr c64.peekw 
            jsr std.print_u16_dec
            
            lda #' '
            jsr sys.CHROUT
            
            lda timer.LATEN
            jsr std.print_u16_dec

            lda #char.nl
            jsr sys.CHROUT
            
            rts
    .pend
    
    start	.proc

            ;   program
 
            ; .............................................. timer
            
            jsr timer.init
            
            jsr print_timer
            
            ;   callback
            .load_address_ay print_num
            jsr timer.start

            jsr timer.stop
            
            jsr print_timer
 
        rts
 

    .pend

.pend

;;;
;;
;

