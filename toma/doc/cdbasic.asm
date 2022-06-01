; ....................................................

; cBasic

; ....................................................


*= $c000

        lda #147        ; clear screen
        jsr $ffd2

        ldy #>cdTitle   ; prompt message 
        lda #<cdTitle     
        jsr STROUT 


        lda #<cBasic:   ; add command parser    
        sta $0308    
        lda #>cBasic:
        sta $0309

        rts

; ....................................................

cdTitle 

    byte $0d
    text "    **** commodore 64 cdbasic v1 ****    "
    byte $0d
    text "basic 39k/64k bytes free, highmem bitmap"
    ;text "            by claudio daffra : gpl 2022"
    byte $00

; ....................................................

CHRGET          = $0073
CHRGOT          = $0079
SNERR           = $AF08
NEWSTT          = $a7ae
GONE            = $a7e4
STROUT          = $ab1e
GETBYTE_CHRGET  = $b79e

charAt  = $40   ;       @
charG   = $47   ;       H
charH   = $48   ;       H
charR   = $52   ;       R
charT   = $54   ;       T
charDP  = $3a   ;       :

; ....................................................


cBasic:

; ........................................... switch level 0

        jsr CHRGET              ; prendi carattere

cBasicCont:
       
        cmp #charAt
        beq newdispatch:
         
        jmp GONE+3

        rts

; ........................................... switch level 1

newdispatch:

        jsr CHRGET 
        
        cmp #charG
        beq newdispatch_G:

        jmp SNERR 

newdispatch_G:

        jsr CHRGET 
        
        cmp #charH
        beq newdispatch_GH:

        cmp #charT
        beq newdispatch_GT:

        jmp SNERR  

; ........................................... switch level 2

newdispatch_GH: ; @GH7,6

        jsr cbBasicHiresColor:
          
        jmp NEWSTT 

        ; IMP : ESCE GIA' con nuovo carattere
        ; ERR : jmp newdispatchSTMT:

newdispatch_GT: ; @GT

        jsr cbBasicGraphText:
                
        jmp newdispatchSTMT:

newdispatchSTMT:

        jsr CHRGET

        jmp NEWSTT

        rts

; .................................................... cBasic LBRARY

; cbBasicGraphHires:
; cbBasicGraphText:

; ....................................................

cbBasicHiresColor:

        jsr cdHiresColor:       ; grafica 320x200

        jsr $b79e               ; get byte into .x && get new char
        stx $fb

        jsr $aefd               ; skip comma

        jsr $b79e               ; get byte into .x && get new char
        stx $fc

        jsr cdBitmapScreenColor:

        jsr cdBitmapClear:

        lda #graphMode320x200
        sta graphMode

        rts

cbBasicGraphText:

        jsr cdTextColor:

        lda #graphMode40x25
        sta graphMode

        rts

; ....................................................
  
    ;jmp main:
    
; .................................................... Global

graphBitMapAddr         =       $E000
graphMode320x200        =       0
graphMode160x200        =       1
graphMode40x25          =       2

graphMode 
      
        byte  graphMode40x25    ; modalità grafica

_graphDrawMode  

        bytes 0                 ; 0 1 erase/put color 0 1 2 3

; .................................................... Color

cBlack          =       0               ;       0000
cWhite          =       1               ;       0001
cRed            =       2               ;       0010
cCyan           =       3               ;       0011
cViolet         =       4               ;       0100
cGreen          =       5               ;       0101
cBlue           =       6               ;       0110
cYellow         =       7               ;       0111

cOrange         =       8               ;       1000
cBrown          =       9               ;       1001
cLightRed       =       10              ;       1010
cDarkGrey       =       11              ;       1011
cGrey2          =       12              ;       1100
cLightGreen     =       13              ;       1101
cLightBlue      =       14              ;       1110
cLightGrey      =       15              ;       1111

cColor0         =       0
cColor1         =       1
cColor2         =       2
cColor3         =       3
cBackGroundColor         =       0
cForeGroundColor         =       1        

; .................................................... 


cdGrafOn:       ;   void

                ;           7654:3210
    lda #$20    ;   0x20  0b0010:0000       32
    ora $d011   ;   bit[5] 1 enable bitmap mode   
    sta $d011   ;   Screen control register #1. Bits:

                ;             7654:3210    
    lda #$38    ;   0x38    0b0011:1000     56
    sta $d018   ;   Memory setup register. Bits: ( BITMAP MODE )
                ;   [7654] 0011 - screen memory 011, 3: $0C00-$0FFF.
                ;   [3]210 1000 - %1xx, 4: $2000-$3FFF, 8192-16383.

                ;             7654:3210
    lda #$fc    ;   0xfc    0b1111:1100 252
    and $dd00   ;   7654:32[10] %00, 0: Bank #3, $C000-$FFFF, 49152-65535.
    sta $dd00   ;   Bits #0-#1: VIC bank. Values:
    
    rts

    ;   abilita modo test

; ....................................................
 
cdTextOn:       ;   void
 
                ;           7654:3210
    lda #$df    ; 0xdf    0b1101:1111  223
    and $d011   ; bit[5] 0 enable text mode
    sta $d011   ; Screen control register #1. Bits:

                ;           7654:3210    
    lda #$15    ; 0x15    0b0001:0101    21
    sta $d018   ; Memory setup register. Bits: ( TEXT MODE )
                ; pointer to character memory
                ; [321]0 0101 - %010 , 2: $1000-$17FF, 4096-6143.
                ; Pointer to screen memory
                ; [7654] 0001 - %0001, 1: $0400-$07FF, 1024-2047.
                 
                ;             7654:3210
    lda #$03    ;   0x03    0b0000:0011 3
    ora $dd00   ;   7654:32[10] %11, 3: Bank #0, $0000-$3FFF, 0-16383.
    sta $dd00   ;   Bits #0-#1: VIC bank. Values:

    rts
    
; ....................................................
    
cdRomDisable:    ;   void

    lda #$fe    ;   0xfe    0b1111:1110 254
    and $dc0e   ;   Bit #0: 0 = Stop timer; 1 = Start timer.
    sta $dc0e   ;   Timer A control register. Bits:
 
                ;             7654:3210 
    lda #$fd    ;   0xfd    0b1111:1101 253
    and $01     ;   %x01:   RAM visible at $A000-$BFFF and $E000-$FFFF..
    sta $01     ;   Bits #0-#2: Configuration for memory areas 
                ;   $A000-$BFFF, $D000-$DFFF and $E000-$FFFF. Values:
    
    rts

; ....................................................
    
cdRomEnable:    ;   void

                ;             7654:3210
    lda #$02    ;   0x02    0b0000:0010    2
    ora $01     ;   %x11: BASIC ROM visible at $A000-$BFFF; KERNAL ROM visible at $E000-$FFFF.
    sta $01     ;   Bits #0-#2: Configuration for memory areas 
                ;   $A000-$BFFF, $D000-$DFFF and $E000-$FFFF. Values:
                 
    lda #$01    ;   0x01    0b0000:0001    1
    ora $dc0e   ;   Bit #0: 0 = Stop timer; 1 = Start timer.
    sta $dc0e   ;   Timer A control register. Bits:

    rts

; ....................................................
    
cdHiresColor:   ;   void

                ;             7654:3210
    lda #$ef    ;   0xef    0b1110:1111
    and $d016   ;   Bit #4: 0 = Multicolor mode off.
    sta $d016   ; Screen control register #2. Bits:    
    
    jsr cdGrafOn:
    
    rts

; ....................................................

cdMultiColor:   ;   void

                ;             7654:3210
    lda #$10    ;   0xef    0b0001:0000
    ora $d016   ;   Bit #4: 1 = Multicolor mode on.
    sta $d016   ; Screen control register #2. Bits:    
    
    jsr cdGrafOn:
    
    rts

; ....................................................

cdTextColor:    ;   void

                ;             7654:3210
    lda #$ef    ;   0xef    0b1110:1111
    and $d016   ;   Bit #4: 0 = Multicolor mode off..
    sta $d016   ; Screen control register #2. Bits:    
    
    jsr cdTextOn:
    
    rts

; ....................................................

cdBitmapClear:

        ;   $F9-$FA     ;   Pointer to RS232 output buffer. Values:
        ;   $00FB-$00FE     ;   unused

        lda     #$e0            ;   E0  load pointer bitmap $e000       ( bank4 $c000 + $2000 ) 
        sta     $fa
 
        lda     #$00            ;   00
        sta     $f9
        
        ldx     #$20
        tay

cdBitmapClearLoop:          ;   clear bitmap    *($f9/$fa) = 0  [00e0]
 
        sta     ($f9),y
        iny
        bne     cdBitmapClearLoop:
        inc     $fa
        dex
        bne     cdBitmapClearLoop:
 
        rts

; ....................................................

cdBitmapScreenColor:

    ;   fb      :   color1
    ;   fc      :   color2
    ;   fd      :   temp
    ;   f9:fa   :   pointer to cc00

    lda #$cc
    sta $fa

    ldy #$00
    sty $f9

    lda $fb     ;   color1
    asl
    asl
    asl
    asl
    ora $fc


cdBitmapScreenColorCustom:  
  
    ldx #$04

cdBitmapScreenColorLoop:

    sta($f9),y
    iny
    bne cdBitmapScreenColorLoop:
    inc $fa
    dex
    bne cdBitmapScreenColorLoop:

    rts

; .................................................... MACRO

defm graphHiresColor

        ; grafica 320x200
        jsr cdHiresColor:

        ; setta cc00 col #1 #2 OK Hires
        lda /2
        sta $fb
        lda /1
        sta $fc
        jsr cdBitmapScreenColor:

        jsr cdBitmapClear:

        lda #graphMode320x200
        sta graphMode

        endm


defm graphMultiColor

        ; grafica 160x200
        jsr cdMultiColor:

        ; setta cc00 col #2 #3
        lda /3
        sta $fb
        lda /2
        sta $fc
        jsr cdBitmapScreenColor:

        jsr cdBitmapClear:

        ; setta col #0 Multi Color
        lda /1
        sta $d021

        ; setta col #4 Multi Color
        lda #$d8
        sta $fa
        lda #$00
        sta $f9
    
        lda /4
        sta $fb
        jsr cdBitmapScreenColorCustom: 

        lda #graphMode160x200
        sta graphMode

        endm

defm graphSetColor

        lda /1
        sta _graphDrawMode

        endm

defm graphMode40x25

        jsr cdTextColor:

        lda #graphMode40x25
        sta graphMode

        endm

; .................................................... tabelle  

pointY          =       $fc
pointX          =       $fa
pointXhi        =       $fa 
pointXlo        =       $fb 
 
; .................................................... table power 2

TabPower2       ; posizione del pixel da accenre o spegnere

        byte $80,$40,$20,$10,$08,$04,$02,$01
        byte %10000000
        byte %01000000
        byte %00100000
        byte %00010000
        byte %00001000
        byte %00000100
        byte %00000010
        byte %00000001

TabHighE000      

        byte $e0,$e1,$e2,$e3
        byte $e5,$e6,$e7,$e8
        byte $ea,$eb,$ec,$ed
        byte $ef,$f0,$f1,$f2
        byte $f4,$f5,$f6,$f7
        byte $f9,$fa,$fb,$fc
        byte $fe

TabLowE000      

        byte $00,$40,$80,$c0
        byte $00,$40,$80,$c0
        byte $00,$40,$80,$c0
        byte $00,$40,$80,$c0
        byte $00,$40,$80,$c0
        byte $00,$40,$80,$c0
        byte $00

; .................................................... graphSetPixel ON/FF
;
;  INPUT :
;
;       $fa     x.hi
;       $fb     x.lo
;       $fc     y

graphSetPixel: 
 
        jsr cdRomDisable:
  
        lda $fc                 ; y in $fc
        tay
        lsr a                   ; y/8
        lsr a
        lsr a
        tax
        lda TabLowE000,x
        sta $fe                 ; low
        lda TabHighE000,x
        clc
        adc $fa                 ; hx in $fa
        sta $ff                 ; high
        tya
        and #$7
        sta $f9                 ; temp
        lda $fb                 ; xl in $fb
        tax
        and #$f8                ; %11111000
        adc $f9                 ; temp
        tay
        txa
        and #$7                 ; (xc and 7)

        ; ................. graphMode320x200

        ; carica dalla tabella il pixel da accendere
        tax
        lda TabPower2,x         ; 2^(7-(xc and 7))

        ldx _graphDrawMode
        beq graphSetPixelOFF:

        ; a = pixel da acccendere ex 0001:0000

graphSetPixelON:

        ora ($fe),y
        jmp  graphSetPixelEND:

graphSetPixelOFF:

        eor #$ff        ;       255 -
        and ($fe),y     ;       peek(ad) and  ma

graphSetPixelEND:

        sta ($fe),y     ;       peek(ad) and  ma

        jsr cdRomEnable:

        rts

        ; ................. graphMode3160x200

mgraphPixel:

        ldx _graphDrawMode

        cpx #0
        beq mgraphPixel00:

        cpx #1
        beq mgraphPixel01:

        cpx #2
        beq mgraphPixel10:

        cpx #3
        beq mgraphPixel11:

        rts

mgraphPixel00:

        graphSetColor #0
        jsr graphSetPixel:

        ;graphSetColor #0
        inc $fb
        jsr graphSetPixel:

        jmp mgraphPixelEND:

mgraphPixel01:

        graphSetColor #0
        jsr graphSetPixel:

        graphSetColor #1
        inc $fb 
        jsr graphSetPixel:

        jmp mgraphPixelEND:

mgraphPixel10:

        graphSetColor #1
        jsr graphSetPixel:

        graphSetColor #0
        inc $fb 
        jsr graphSetPixel:

        jmp mgraphPixelEND:

mgraphPixel11:

        graphSetColor #1
        jsr graphSetPixel:

        ;graphSetColor #1
        inc $fb 
        jsr graphSetPixel:

        ;jmp mgraphPixelEND:

mgraphPixelEND:

        jsr cdRomEnable:

        rts

; .................................................... Macro

testHiresColor:

        graphHiresColor #cBlack,#cWhite

        ;  ................................ plot point      

        graphSetColor #1

        lda #0    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #0
        sta $fb
        jsr graphSetPixel:


        lda #2    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #2
        sta $fb
        jsr graphSetPixel:


        lda #4    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #4
        sta $fb
        jsr graphSetPixel:


        lda #6    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #6
        sta $fb
        jsr graphSetPixel:


        lda #8    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #8
        sta $fb
        jsr graphSetPixel:


        lda #10    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #10
        sta $fb
        jsr graphSetPixel:

        lda #12    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #12
        sta $fb
        jsr graphSetPixel:

        lda #14    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #14
        sta $fb
        jsr graphSetPixel:

        ;

        ;jsr cdTextColor:

        rts

testMultiColor:

        graphMultiColor #cCyan,#cYellow,#cRed,#cWhite

        graphSetColor #1

        lda #0    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #0
        sta $fb
        jsr mgraphPixel:

        graphSetColor #2

        lda #2    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #2
        sta $fb
        jsr mgraphPixel:

        graphSetColor #3

        lda #4    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #4
        sta $fb
        jsr mgraphPixel:

        graphSetColor #0

        lda #6    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #6
        sta $fb
        jsr mgraphPixel:

       graphSetColor #1

        lda #8    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #8
        sta $fb
        jsr mgraphPixel:

       graphSetColor #2

        lda #10    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #10
        sta $fb
        jsr mgraphPixel:

       graphSetColor #3

        lda #12    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #12
        sta $fb
        jsr mgraphPixel:

       graphSetColor #2

        lda #14    ;       y
        sta $fc
        lda #0    ;       x
        sta $fa
        lda #14
        sta $fb
        jsr mgraphPixel:

        ;jsr cdTextColor:

        rts


; .................................................... MAIN

;*= $0801
 
main:

        ;jsr testHiresColor:
        jsr testMultiColor:

        rts


;;;
;;
;


