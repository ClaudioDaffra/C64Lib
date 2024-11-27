
; 10 SYS (2305)

*=$0801


        sei
        bit $d011 ; Wait for new frame
        bpl *-3
        bit $d011
        bmi *-3

        lda #$ff ; Enable sprites
        sta $d015

        ldx #14 ; Set some x-positions
        clc
        lda #$f0
        sta $d000,x
        sbc #$18
        dex
        dex
        bpl *-7

        ldx #14 ; Set some y-positions
        lda #$40
        sta $d001,x
        dex
        dex
        bpl *-5

        lda #$24 ; Set sprite pointers to display this code :).
        ldx #7
        sta $07f8,x
        dex
        bpl *-4

        lda #$bd ; Set idle-pattern
        sta $3fff
loop1
        jsr StretchCalc ; Make beautiful stretching.

        lda #$40 ; Wait for sprite y-position
        cmp $d012
        bne *-3

        ldx #4 ; Wait a few cycles to make the d017-stretch work
        dex
        bne *-1

        ldx #0
loop2
        lda StretchTab,x ; $ff will stretch, 0 will step one line of graphics in the sprite
        sta $d017

        sec
        lda $d011
        sbc #7
        ora #$18
        sta $d011 ; Step d011 each line to avoid badlines

        bit $ea ; Make the whole loop 44 cycles = one raster line when using 8 sprites
        nop
        nop
        nop

        lda #0 ; Set back for the next line
        sta $d017

        inx
        cpx #100
        bne loop2 ; Loop 100 times

        lda #$1b ; Set back char-screen mode
        sta $d011
        jmp loop1

StretchCalc ; Setup the stretch table
        ldy #0
        sty YPos
        lda #$ff ; First clear the table
        sta StretchTab,y
        iny
        bne *-4

        lda #0 ; Increase the starting value
        inc *-1
        asl
        sta AddVal

        ldy #0 ; This loop will insert 16 0:s into the table..
               ; At those positions the sprites will not stretch
SFT_1
        lda AddVal
        clc
        adc #10
        sta AddVal
        bpl *+4
        eor #$ff
        lsr
        lsr
        lsr
        lsr
        sec
        adc YPos
        sta YPos
        tax
        lda #0
        sta StretchTab,x
        iny
        cpy #20
        bcc SFT_1
        rts

YPos    byte 0
AddVal  byte 0

        ;.align $100 ; Align the table to a new page, this way lda StretchTab,x always takes 4 cycles.
StretchTab
        ; 
 byte 255,255,0
 byte 0,0,0
 byte 32,0,12
 byte 16,0,24
 byte 24,0,16
 byte 12,0,32
 byte 6,0,64
 byte 3,0,192
 byte 0,129,128
 byte 0,65,0
 byte 0,34,0
 byte 0,28,0
 byte 0,8,0
 byte 0,44,0
 byte 0,198,0
 byte 1,3,0
 byte 2,0,128
 byte 8,0,112
 byte 16,0,24
 byte 64,0,4
 byte 0,0,0

; 
 byte 0,0,0
 byte 96,0,6
 byte 32,0,12
 byte 16,0,24
 byte 8,0,112
 byte 12,0,192
 byte 2,3,0
 byte 3,6,0
 byte 1,152,0
 byte 0,240,0
 byte 0,96,0
 byte 0,160,0
 byte 1,144,0
 byte 3,24,0
 byte 6,6,0
 byte 4,3,0
 byte 24,0,192
 byte 16,0,96
 byte 32,0,48
 byte 64,0,24
 byte 0,0,0





