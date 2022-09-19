
;       TODO start in bank4
;       TODO basic pointer -1024
;       TODO screen address to cc00
;       TODO @ht stay in bank 4
;       TODO get memory free

; ....................................................

; cBasic

; ....................................................


; .................................................... KERNAL

CHRGET          = $0073 
CHRGOT          = $0079
SNERR           = $AF08 
NEWSTT          = $a7ae 
GONE            = $a7e4
STROUT          = $ab1e
GETBYTE_CHRGET  = $b79e 
GETDEC          = $A96B
printNumAX      = $BDCD
chrget          = $0073
chrgot          = $0079
ieval           = $030a ; Execution address of routine reading next 
                        ; item of BASIC expression. ( AE86 )

; ....................................................


*= $c000

        ; ........................... main message

        lda #147        ; clear screen
        jsr $ffd2

        ldy #>cdTitle   ; prompt message 
        lda #<cdTitle     
        jsr STROUT 

        ; ........................... HOOK command


        lda #<cBasic:   ; add command parser    
        sta $0308    
        lda #>cBasic:
        sta $0309

        ; ........................... HOOK expression

        lda #<cdBasicEvalHex:
        sta ieval
        lda #>cdBasicEvalHex:
        sta ieval+1

        ; ........................... HOOK raster

jmp end

                sei

                lda #$7f        ;       disable
                sta $dc0d       ;       CIA1
                lda $dc0d

                ldx #<subRasterIRQ:
                ldy #>subRasterIRQ:
                
                ;jsr setIRQ
                stx     $0314   ;       hook irq
                sty     $0315
                sta     $d012   ;       save raster position

                lda     #01
                sta     $d019   ;       VIC interrupt request IRR
                sta     $d01a   ;       VIC interrupt Mask    IMR

                lda #$1b       ;       set VIC default
                sta $D011

                cli     

end

        rts

; .................................................... COPYRIGHT

cdTitle 

    byte $0d
    text "   **** commodore 64 cd basic v1 ****    "
    byte $0d
    text "basic 39k/64k bytes free, highmem bitmap"
    byte $00



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

; .................................................... PETASCII

charDollar      = $24   ;       $
charAt          = $40   ;       @

charB           = $42   ;       B
charC           = $43   ;       C
charG           = $47   ;       G
charH           = $48   ;       H
charM           = $4d   ;       M
charP           = $50   ;       P
charR           = $52   ;       R
charS           = $53   ;       S
charT           = $54   ;       T

charW           = $57   ;       W
charX           = $58   ;       X

charDP          = $3a   ;       :


; .................................................... #define

graphBitMapAddr         =       $E000
graphMode320x200        =       0
graphMode160x200        =       1
graphMode40x25          =       2
graphMode40x25Ext       =       3

; .................................................... #global

graphMode 
      
        byte  graphMode40x25   ; modalità grafica

_graphDrawMode  

        byte  0                ; 0 1 erase/put color 0 1 2 3

_screenAddr  

        word  1024             ; screen address

;

; .................................................... cBasic

cBasic:

; ....................................................

;

; ---------------------------------------------  switch level 0

        jsr CHRGET              ; prendi carattere

        cmp #charAt             ; @
        beq newdispatch:
         
        jmp GONE+3

        rts

; ---------------------------------------------  switch level 1

newdispatch:

        jsr CHRGET 
        
        cmp #charG              ;       G
        beq newdispatch_G:

        cmp #charB              ;       B
        beq newdispatch_B:

        cmp #charS              ;       S
        beq newdispatch_S:

        cmp #charDolLar         ;       $
        beq newdispatch_Dollar:

        jmp SNERR 

newdispatch_Dollar:

        jsr cbBasicHexDecimal:
          
        jmp NEWSTT 

newdispatch_G:

        jsr CHRGET 
        
        cmp #charH
        beq newdispatch_GH:

        cmp #charT
        beq newdispatch_GT:

        cmp #charC
        beq newdispatch_GC:

        cmp #charM
        beq newdispatch_GM:

        cmp #charW
        beq newdispatch_GW:

        jmp SNERR  

newdispatch_B:

        jsr CHRGET 
        
        cmp #charP
        beq newdispatch_BP:

        jmp SNERR  

newdispatch_S:

        jsr CHRGET 

        cmp #charR
        beq newdispatch_SR:

        jmp SNERR 

; ---------------------------------------------  switch level 2

newdispatch_GH: ; @GH background,foreground :: ( byte,byte )

        jsr cbBasicHiresColor:
          
        jmp NEWSTT 

newdispatch_GT: ; @GT ext,(1,2,3,4)

        jsr cbBasicGraphText:
                
        ;jmp newdispatchSTMT:;   ( void )

        jmp NEWSTT

newdispatch_GC: ; @GC1 col  :: ( 0 ON 1 Off - 0123 Multi Color )

        jsr cbBasicGraphColor:

        jmp NEWSTT 

newdispatch_GM: ; @GM0,1,2,3

        jsr cbBasicGraphMultiColor:


        jmp NEWSTT 

newdispatch_GW: ; @GW

        ;jsr cbBasicGraphMultiColor:
        ;jsr CHRGET
        jmp NEWSTT 

; ...........................................

newdispatch_BP: ; @BP  x,y  :: ( word , byte )

        jsr CHRGET 

        cmp #charX
        beq newdispatch_BPX:

        jmp SNERR 

newdispatch_SR:

        jsr CHRGET 

        cmp #charC
        beq newdispatch_SRC:

        jmp SNERR 

; --------------------------------------------- switch level 3

newdispatch_BPX:        ;       @BPX x,y

        jsr cbBasicDrawPixel:

        jmp NEWSTT 

newdispatch_SRC:        ;       @SRC R,C

        jsr cbScreenRC:

        jmp NEWSTT 

; --------------------------------------------- end 

newdispatchSTMT:  

        jsr CHRGET

        jmp NEWSTT

        rts

; .................................................... cBasic LBRARY

; cbBasicGraphHires:    @GH
; cbBasicGraphText:     @GT
; cbBasicGraphColor:    @GC
; cbBasicGraphColor:    @GM
; cbBasicBitmapPixel:   @BPX
; cbBasiccreenRC:       @SRC

; ....................................................

cbBasicHiresColor:              ; @gh  bg,fg

        jsr cdHiresColor:       ; grafica 320x200

        jsr CHRGET

        jsr $b79e               ; get byte into .x && get new char
        stx $fb

        jsr $aefd               ; skip comma

        jsr $b79e               ; get byte into .x && get new char
        stx $fc

        jsr cdBitmapScreenColor:

        jsr cdBitmapClear:

        lda #graphMode320x200
        sta graphMode

        ; TODO _screenAddr

        rts

; ....................................................


cbBasicGraphMultiColor:         ; @gm  c0,c1,c2,c3

        ; TODO get 4 parameter byte

        ; grafica 160x200
        jsr cdMultiColor:

        jsr CHRGET

        jsr $b79e               ; get byte into .x && get new char
        stx $d021               ; setta col #0 Multi Color

        jsr $aefd               ; skip comma

        ; setta cc00 col #2 #3

        jsr $b79e               ; get byte into .x && get new char
        stx $fc                 ; #2               

        jsr $aefd               ; skip comma

        jsr $b79e               ; get byte into .x && get new char
        stx $fb                 ; #3              

        jsr $aefd               ; skip comma

        jsr cdBitmapScreenColor:

        jsr cdBitmapClear:

        jsr $b79e               ; get byte into .x && get new char
        stx $fb                 ; #4      

        ; setta col #4 Multi Color
        lda #$d8
        sta $fa
        lda #$00
        sta $f9

        jsr cdBitmapScreenColorCustom: 

        lda #graphMode160x200
        sta graphMode

        ; TODO _screenAddr

        rts

;..............................................................

cbBasicGraphText:               ; @gt   ext     ( 0 off , 1 on )

        jsr cdTextColor:

        ; default colour mode

        lda #graphMode40x25
        sta graphMode

        lda $D011               ; OFF extend color mode
        and #%10111111
        sta $d011

        jsr CHRGET
        jsr $b79e               ; get byte into .x && get new char

        cpx #$00                ; EXT OFF
        beq cbBasicGraphTextExit:

        ; extended colour mode

        lda #graphMode40x25Ext
        sta graphMode

        lda $D011               ; ON extend color mode
        ora #%01000000
        sta $d011

        ; TODO get 4 parameter byte

        ;  get 4 color

        jsr CHRGET

        jsr $b79e               ; #0 get byte into .x && get new char
        stx 53281

        JSR $AEFD               ;       comma

        jsr $b79e               ; #1 get byte into .x && get new char
        stx 53282

        JSR $AEFD               ;       comma

        jsr $b79e               ; #2 get byte into .x && get new char
        stx 53283

        JSR $AEFD               ;       comma

        jsr $b79e               ; #3 get byte into .x && get new char
        stx 53284

        ;jmp newdispatchSTMT:;   ( void )

cbBasicGraphTextExit:

        rts

;..............................................................

cbBasicGraphColor:       ; @gc

        ; TODO if hires check color < 2
        ; TODO if lorer check color < 4

        jsr CHRGET
        jsr $b79e               ; get byte into .x && get new char
        stx _graphDrawMode

        rts

;..............................................................

cbBasicDrawPixel:       ; @bpx

        jsr CHRGET
        JSR $AD8A       ;        get non string value
        JSR $B7F7       ;        convert float ti integer in $14/$15

        lda $14         ;       [X]:word        fa:fb
        sta $fb         ;       HI 14/LO

        lda $15
        sta $fa         ;       LO 14/HI        

        JSR $AEFD       ;       comma

        jsr $b79e       ;       get byte into .x && get new char
        stx $fc         ;       [Y]:byte        fc


        ; TODO check x <320
        ; TODO check y <200

        ; TODO check _graphDrawMode 
        ; 0     :  jsr graphSetPixel:
        ; 1     :  jsr mgraphSetPixel: 
    
        lda graphMode

        cmp #graphMode320x200
        beq cbBasicDrawPixelHR:

        cmp #graphMode160x200
        beq cbBasicDrawPixelMC:

        rts

cbBasicDrawPixelHR:
        
        jmp graphSetPixel:      ; disegna pixel Hires Color

        rts

cbBasicDrawPixelMC:
 
        ;fa/hi;fb/lo * 2
        ASL $FB;LO
        ROL $FA;HI

        jmp mgraphPixel:        ; disegna pixel Multi Color

        rts

;..............................................................

cbScreenRC:

        jsr CHRGET

        jsr $b79e       ; get byte into .x && get new char
        stx $02         ;Store .X in temporary location

        JSR $AEFD       ;       comma

        jsr $b79e       ; get byte into .x && get new char
        ldy $02         ;Load .Y with previously saved/evaluated value

        clc

        jsr $fff0

        rts

;..............................................................


cbBasicHexDecimal:

        jsr CHRGET

        ;jsr $ae86       ;       ???

        lda #$0
        sta $14
        lda #$1
        sta $15

        rts



; --------------------------------------------------------

Incasm "cdLibrary.asm"

; --------------------------------------------------------

