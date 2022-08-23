
; .................................................... MAIN

; PROGRAM

* = $c000

; INCLUDE

Incasm "C:\c64.lib\lib.src\math.asm"

*= $6000

; MAIN



        lda #00 ;@      a       -320
        ldx #00 ;@      a

        sta num16_1lo
        stx num16_1hi

        lda #$01        ; 0001
        ldx #$00

        sta num16_2lo
        stx num16_2hi

        jsr sub16

; 00 ff

        rts

