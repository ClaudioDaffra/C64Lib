;Top Raster
RASTER1 = (8*(00))+50

;Bottom Raster
RASTER2 = (8*(12))+50

        * = $c000

;Clear the bitmap $2000-$3fff
        lda #$55
        ldx #>$3fff-$2000
        ldy #$00
SRCE    sta $2000,y
        dey
        bne SRCE
        inc SRCE+2
        dex
        bpl SRCE

;Set Up The IRQ
        sei
        lda #$7F     ;Disable
        sta $DC0D    ;CIA1: CIA Interrupt Control Register
        lda $DC0D    ;CIA1: CIA Interrupt Control Register
        ldx #<IRQ1
        ldy #>IRQ1
        jsr SET_IRQ
        lda #$1b
        sta $D011    ;VIC Control Register 1
        cli

        rts

;------------------------------------------------------------------------------
; Interrupt
IRQ1

;Wait For The Beam
        lda #RASTER1
-       cmp $D012    ;Raster Position
        bne -

; Waste Some Time
        ldy #$0A
-       dey
        bne -

;Set The VIC-II
        lda #$d8     ;40 columns. Multicolor mode on.
        sta $D016    ;VIC Control Register 2
        lda #$3b     ;Mode: Multicolor Bitmap (ECM/BMM/MCM=0/1/1)
        sta $d011    ;VIC Control Register 1
        lda #$1d     ;Video $0400, Bitmap $2000 (RAM)
        sta $D018    ;VIC Memory Control Register

;Wait For The Beam
        lda #RASTER2
-       cmp $D012    ;Raster Position
        bne -

; Waste Some Time
        ldy #$0A
-       dey
        bne -

;Set The VIC-II
        lda #$c8     ;40 columns. Multicolor mode off.
        sta $D016    ;VIC Control Register 2
        lda #$1b     ;Mode: Standard Text (ECM/BMM/MCM=0/0/0)
        sta $d011    ;VIC Control Register 1
        lda #$15     ;Video $0400, Charset $1000
        sta $D018    ;VIC Memory Control Register

;ACK the IRQ
        inc $D019    ;VIC Interrupt Request Register (IRR)

;Exit to basic
        jmp $EA31

;------------------------------------------------------------------------------
;SET IRQ
SET_IRQ

        stx $0314    ;IRQ
        sty $0315    ;IRQ
        sta $D012    ;Raster Position

        lda #$01     ;Acknowledge raster interrupt.
        sta $D019    ;VIC Interrupt Request Register (IRR)
        sta $D01A    ;VIC Interrupt Mask Register (IMR)

        rts
        
        
;;;
;;
;
