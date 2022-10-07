

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

    ;jmp program
    jmp main.start
    
;--------------------------------------------------------------- lib

.include "../../lib/libC64.asm"

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
            
        ;   
        ;   iAN CooG
        ;   iAN CooG
        ;   16 mar 2011, 23:33:38
        ;   
        ;   You probably set wrong d018 value or even forgot to add your own charset. If
        ;   you want to use ROM charset simply copy it somewhere in the same bank, it's
        ;   handy to have it on the same ROM address at $d000, the RAM under $d000 is
        ;   rarely used.

                   
                   ;-------------------------
                    charset = $d000
                    screen  = $F000
                    ;calc d018/bank values
                    ns = >screen<<2
                    nc = (>charset&$3f)>>2
                    v18 = (ns|nc)&$ff
                    bank = 3-(>screen>>6)
                    ;-------------------------

                    ; save cursorpos
                    ;jsr $e513
                    ;stx $fd
                    ;sty $fe

                    ; set the vic bank and screen/charset in use
                    lda #v18
                    sta $d018
                    
lda $dd00
and #$fc
ora #bank
sta $dd00

    ; copy charset from chargen to the RAM at the same address
    ; else load your favourite charset here
    sei
    ldx #$08
    lda #$33 ; see the chargen at $d000
    sta $01
    lda #>charset
    sta $fc
    ldy #$00
    sty $fb
lp1
    lda ($fb),y
    inc $01
    sta ($fb),y
    dec $01
    iny
    bne lp1
    inc $fc
    dex
    bne lp1
    lda #$37 ; ROM active
    sta $01
    cli

                    ; now let's "print" something by writing directly on the new screen.
                    ; write on RAM while ROM is active, VIC-II always sees the RAM
                    ; apart the chargen shadow copies at $1xxx and $9xxx.
                    
                    ldy #(etext-ctext-1)
              ptext
                    lda ctext,y
                    sta screen,y
                    dey
                    bpl ptext
                    jsr k1

                    ; the KERNAL still uses the screen at $0400
                    ; let's point it to the new screen
                    lda #>screen
                    sta $0288
                    jsr $e544
                    ldy #>ttext
                    lda #<ttext
                    jsr $ab1e
                    jsr k1

                    ; now let's get back to normal (beware: color RAM is altered)
                    lda #$04
                    sta $0288
                    
                    lda #$14
                    sta $d018
                    
                    lda $dd00
                    and #$fc
                    ora #$03
                    sta $dd00
                    
                    ldx $fd
                    ldy $fe
                    jmp $e50c

                    ;--------------
                k1
                    jsr $ffe4
                    beq k1
                    rts

                    ctext
                    ttext .null "claudio daffra"
                    etext

 
        rts
 

    .pend

.pend

;;;
;;
;

