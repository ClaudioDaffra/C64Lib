
;**********
;           graph
;**********

graph .proc

        ; ------------------------------------------------- bitmap address
        
        ;   c64.bitmap_addr
        ;   
        ;   ** 0010 0101
        ;   
        ;   screen   0010    0800
        ;   bitmap   0101    2000
        ;   
        ;   bank 4
        ;
        ;   c000  49152 (2048)    //        2k
        ;   c800  51200 (1024)    screen    1k
        ;   cc00  52224 (256)     //        0,5k
        ;   cd00        (256)     //
        ;   ce00        (256)     stack hi  0,5k
        ;   cf00        (256)     stack lo

        ; ------------------------------------------------- 
        
        max_x   = 320
        max_y   = 200

        ; ------------------------------------------------- struct graph.   aliases
        
        color0              =   screen.background_color_0   ;   (0)
        color1              =   screen.background_color_1   ;   (1)

        color2              =   screen.background_color_2   ;   (2)
        color3              =   screen.background_color_3   ;   (3)
        
        background_color    =   screen.background_color
        foreground_color    =   screen.foreground_color
        color_number        =   screen.foreground_color

        ; ------------------------------------------------- high 
        
        high    .proc
        
             on    .proc                                ; TODO  c800 0400
                jsr c64.set_bitmap_mode_320x200_on
                jsr c64.set_screen_0400_bitmap_2000_addr
                rts
            .pend
            
            off    .proc   ;   0400
                jsr c64.set_bitmap_mode_320x200_off
                jsr c64.set_screen_0400_bitmap_2000_addr
                rts
            .pend

            set_color .proc   ;   a:background    y:foreground
                lda screen.foreground_color
                sta screen.background_color_2
                
                lda screen.background_color
                sta screen.background_color_3
                
                jsr txt.set_char_with_col_2_3
                
                jsr txt.clear_screen_chars 
                
                rts
            .pend

        .pend
        
        ; ------------------------------------------------- low
        
        low    .proc
        
            on    .proc                                ; TODO  c800 0400
                jsr c64.set_bitmap_mode_160x200_on
                jsr c64.set_screen_0400_bitmap_2000_addr
                rts
            .pend
            
            off    .proc   ;   0400
                jsr c64.set_bitmap_mode_160x200_off
                jsr c64.set_screen_0400_bitmap_2000_addr
                rts
            .pend
            
            set_color .proc
                lda screen.background_color_0   ; #0
                sta $d021

                lda screen.background_color_1   ; #1 #2
                asl
                asl
                asl
                asl 
                ora  screen.background_color_2

                jsr txt.clear_screen_chars

                lda screen.background_color_3   ; #3
                jsr txt.clear_screen_colors

                rts
             .pend
             
        .pend

        ; -------------------------------------------------     pixel
        
        pixel .proc
        
                N   =   graph.color_number   ;  color number
                Y   =   zpy                  ;  coord y
                X   =   zpWord0              ;  coord x
                
                P   =   zpWord1              ;  graph P address

                lda c64.screen_control_register_2   ;   check multi color
                and #%00010000
                beq pixel_xy                        ;   se modolaità hires
                
                ; if MC mul by 2
                lda X
                asl 
                sta X
                lda X+1
                rol
                sta X+1

        pixel_xy

                lda checkXY ;   1 check 0 skip
                beq start
                
            ;   check range 0-320 X,    0-200 Y.         
            checkY
                lda Y
                cmp #200
                blt start
                bge overflow
            checkX
                 ;16-bit number comparison...
                 lda X+1        ;MSB of 1st number
                 cmp #$01       ;MSB of 2nd number
                 bcc islower    ;X < Y
                 bne overflow   ;X > Y
                 lda X          ;LSB of 1st number
                 cmp #$40       ;LSB of 2nd number
                 bcc islower    ;X < Y
                 beq overflow   ;X = Y
                 bne overflow   ;X > Y
             islower

                jmp start
            overflow
                .sev
                rts

        start
        
                ;   calc Y-cell, divide by 8	y/8 is y-cell table index

                lda Y
                lsr                     ;   / 2
                lsr                     ;   / 4
                lsr                     ;   / 8
                tay                     ;   tbl_8,y index  (Y)

                ;............................calc X-cell, divide by 8 divide 2-byte X / 8

                ror X+1                 ;   rotate the high byte into carry flag
                lda X
                ror                     ;   lo byte / 2 (rotate C into low byte)
                lsr                     ;   lo byte / 4
                lsr                     ;   lo byte / 8
                tax                     ;   tbl_8,x index  (X)
                
                ;............................add x & y to calc cell point is in

                clc

                lda tbl_vbaseLo,y       ;   table of _graphBitMap row base addresses
                adc tbl_8Lo,x           ;   + (8 * Xcell)
                sta P                   ;   = cell address

                lda tbl_vbaseHi,y       ;   do the high byte
                adc tbl_8Hi,x
                sta P+1

                ;...........................    get in-cell offset to point (0-7)

                lda X                   ;   get X offset from cell topleft
                and #%00000111          ;   3 lowest bits = (0-7)
                tax                     ;   put into index register

                lda Y                   ;   get Y offset from cell topleft
                and #%00000111          ;   3 lowest bits = (0-7)
                tay                     ;   put into index register
    
                ;................................................................   check HR LO res

                lda c64.screen_control_register_2   ;   check multi color
                and #%00010000
                bne plotPointMC

                ;................................................................   _plotPointHR
                
        plotPointHR

                lda N                   ;   (0 = erase, 1 = set)
                beq erase               ;   if = 0 then branch to clear the point

                ;..................     set point

                    .if c64.bitmap_addr == $E000
                    jsr c64.mem.to_ram_AE
                    .endif
                    
                    lda (P),y           ;   get row with point in it
                    ora tbl_orbit,x     ;   isolate and set the point
                    sta (P),y           ;   write back to _graphBitMap

                    .if c64.bitmap_addr == $E000
                    jsr c64.mem.to_rom_AE
                    .endif
                    
                    jmp past            ;   skip the erase-point section

                ;..................     unset point

                    erase:              ;   handled same way as setting a point

                    .if c64.bitmap_addr == $E000
                    jsr c64.mem.to_ram_AE
                    .endif
                    
                    lda (P),y           ;   just with opposite bit-mask
                    and tbl_andbit,x    ;   isolate and erase the point
                    sta (P),y           ;   write back to _graphBitMap

                    past:
                    
                    .if c64.bitmap_addr == $E000
                    jsr c64.mem.to_rom_AE
                    .endif
                
                rts
                
                ;................................................................   _plotPointMC
                
        plotPointMC

                    .if c64.bitmap_addr == $E000
                    jsr c64.mem.to_ram_AE
                    .endif
                    
                    lda (P),y                   ;erase couple of bit 
                    and tblMC_andbitbit,x  
                    sta (P),y                 
                    
                    pha                         ; salva risultato

                    lda N                       ; get number color
                    
                    cmp #1
                    beq _plotPointMC_01
                    cmp #2
                    beq _plotPointMC_10
                    cmp #3
                    beq _plotPointMC_11	
                    
                    pla

                    .if c64.bitmap_addr == $E000
                    jsr c64.mem.to_rom_AE
                    .endif
                    
                    rts

                _plotPointMC_00:       ;     already reset (color0)
                
                _plotPointMC_01:

                    pla 
                    ora tblMC_orbitbit01,x 
                    jmp _plotPointMC_end

                _plotPointMC_10:

                    pla 
                    ora tblMC_orbitbit10,x 
                    jmp _plotPointMC_end

                _plotPointMC_11:

                    pla 
                    ora tblMC_orbitbit11,x 

                _plotPointMC_end:

                    sta (P),y 

                    .if c64.bitmap_addr == $E000
                    jsr c64.mem.to_rom_AE
                    .endif

                    rts
        checkXY .byte   0
        .pend

        ;............................................................ horizontal_line
        ;
        ;       zpWord0 x
        ;       ay      length
        ;       zpy     y
        
        horizontal_line    .proc
        
            ;   maxLength
            sta lengthMax       ;   lunghezza massima
            sty lengthMax+1
            
            ; coordX
            lda zpWord0
            sta coordX
            lda zpWord0+1
            sta coordX+1

            lda #0
            sta length
            lda #0
            sta length+1
            
            ;   coordy
            ldy zpy
            ;sty coordY

        loop
        
            .u16_add_1   coordX
            
            ;16-bit number comparison...
             lda coordX+1   ;MSB of 1st number
             cmp #$01       ;MSB of 2nd number
             bcc islower    ;X < Y
             bne exit       ;X > Y
             lda coordX     ;LSB of 1st number
             cmp #$40       ;LSB of 2nd number
             bcc islower    ;X < Y
             beq exit       ;X = Y
             bne exit       ;X > Y
         islower
            
            ;   zpWord0
            .copy_u16    zpWord0 , coordX
            ;   zpy
            jsr graph.pixel ;   (zpy ,zpWord0)

            .u16_add_1   length

            lda length+1
            cmp lengthMax+1
            bne +
            lda length+0
            cmp lengthMax+0
        + 
            bcc loop  ;   lower
            bne loop  ;   higher
        exit
            rts
            
        length      .word   0
        lengthMax   .word   0
        coordX      .word   0
        
        .pend

        ;............................................................ vertical_line
        ;
        ;   input   :
        ;
        ;               zpWord0 X
        ;               zpy     Y
        ;               a       height
        ;
        
        vertical_line    .proc

            sta  length
            
            .copy_u16 coordX,zpWord0

            lda  length
            
            beq  +
        -
            ; zpWord0
            ; zpy
            .copy_u16 zpWord0,coordX
            
            ldy zpy
            iny
            sty zpy
            
            jsr  graph.pixel

            ldy zpy             ; check <200
            cpy #200
            bge +

            dec length
            
            bne  -
        +
            rts
        length   .byte   0
        coordX   .word   0
        .pend

        ; .................................................... bitmap clear

        bitmap_clear   .proc         
                                ;   ( bank3 00 $c000 + $2000 ) -> $E000
                                ;   ( bank0 11 $0000 + $2000 ) -> $2000
                ldx     #$20
                ldy     #$00

        -      ;   clear bitmap 
         
                sta     (zpWord0),y
                iny
                bne     -
                inc     zpWord0+1
                dex
                bne     -
         
                rts
        .pend
            
        ;
        ;
        ;
        
;**********
;           Tabelle
;**********

table_begin

    ;******
    ;       TABELLE XY
    ;******
    
    tbl_vbase   :=  c64.bitmap_addr + range(0, 26, 1) * 320

    tbl_vbaseLo   .byte < tbl_vbase

    tbl_vbaseHi   .byte > tbl_vbase

    ;
    
    tbl_8       :=  0+range(0, 41, 1) * 8 

    tbl_8Lo     .byte < tbl_8

    tbl_8Hi     .byte > tbl_8

    ;
    
    ;******
    ;       TABELLE HI RES
    ;******

    tbl_orbit =*

    .byte %10000000
    .byte %01000000
    .byte %00100000
    .byte %00010000
    .byte %00001000
    .byte %00000100
    .byte %00000010
    .byte %00000001

    tbl_andbit =*

    .byte %01111111
    .byte %10111111
    .byte %11011111
    .byte %11101111
    .byte %11110111
    .byte %11111011
    .byte %11111101
    .byte %11111110

    ;******
    ;       TABELLE LO RES
    ;******

    ; ................................. AND Mc azzera coppia di bit

    tblMC_andbitbit =*

    .byte %00111111
    .byte %00111111
    .byte %11001111
    .byte %11001111
    .byte %11110011
    .byte %11110011
    .byte %11111100
    .byte %11111100

    ; ................................. AND Mc accende coppia di bit

    tblMC_orbitbit =*

    ; ................................. col 0 00

    tblMC_orbitbit00 =*

    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    ; ................................. col 1 01

    tblMC_orbitbit01 =*

    .byte %01000000
    .byte %01000000
    .byte %00010000
    .byte %00010000
    .byte %00000100
    .byte %00000100
    .byte %00000001
    .byte %00000001

    ; ................................. col 2 10

    tblMC_orbitbit10 =*

    .byte %10000000
    .byte %10000000
    .byte %00100000
    .byte %00100000
    .byte %00001000
    .byte %00001000
    .byte %00000010
    .byte %00000010

    ; ................................. col 3 11

    tblMC_orbitbit11 =*

    .byte %11000000
    .byte %11000000
    .byte %00110000
    .byte %00110000
    .byte %00001100
    .byte %00001100
    .byte %00000011
    .byte %00000011


    table_end

        ;
        ;
        ;

        ;***********
        ;   BANK
        ;***********
        
        ; .................................................... bank3

        bank3    .proc

            ; ....................................................
            ;            
            ;   { Bitmap(+2000) , Screen(+0C00) , Bank(C000) }
            ;
            
            bitmap_E000_screen_CC00_graf_ON

                            ;           76543210
                lda #$20    ;   0x20  0b00100000       32
                ora $d011   ;   bit[5] 1 enable bitmap mode   
                sta $d011   ;   Screen control register #1. Bits

                            ;             76543210    
                lda #$38    ;   0x38    0b00111000     56
                sta $d018   ;   Memory setup register. Bits ( BITMAP MODE )
                            ;   [7654] 0011 - screen memory 011, 3 $0C00-$0FFF.
                            ;   [3]210 1000 - %1xx, 4 $2000-$3FFF, 8192-16383.

                            ;             76543210
                lda #$fc    ;   0xfc    0b11111100 252
                and $dd00   ;   765432[10] %00, 0 Bank #3, $C000-$FFFF, 49152-65535.
                sta $dd00   ;   Bits #0-#1 VIC bank. Values
                
                lda # ( $CC00 / 256 ) 
                sta c64.SCRPTR
                
                rts

            ; .................................................... hires on

            hires_bitmap_E000_screen_CC00_ON

                            ;             76543210
                lda #$ef    ;   0xef    0b11101111
                and $d016   ;   Bit #4 0 = Multicolor mode off.
                sta $d016   ; Screen control register #2. Bits    
                
                jsr bitmap_E000_screen_CC00_graf_ON
                
                rts

            ; ....................................................  hires_on

            multi_bitmap_E000_screen_CC00_ON

                            ;             76543210
                lda #$10    ;   0xef    0b00010000
                ora $d016   ;   Bit #4 1 = Multicolor mode on.
                sta $d016   ; Screen control register #2. Bits    
                
                jsr bitmap_E000_screen_CC00_graf_ON
                
                rts

            ; ....................................................
            ;            
            ;   { Bitmap(+2000) , Screen(+0400) , Bank(0000) }
            ;
            
            bitmap_E000_screen_CC00_graf_OFF
             
                            ;           76543210
                lda #$df    ; 0xdf    0b11011111  223
                and $d011   ; bit[5] 0 enable text mode
                sta $d011   ; Screen control register #1. Bits

                            ;           76543210    
                lda #$15    ; 0x15    0b00010101    21
                sta $d018   ; Memory setup register. Bits ( TEXT MODE )
                            ; pointer to character memory
                            ; [321]0 0101 - %010 , 2 $1000-$17FF, 4096-6143.
                            ; Pointer to screen memory
                            ; [7654] 0001 - %0001, 1 $0400-$07FF, 1024-2047.
                             
                            ;             76543210
                lda #$03    ;   0x03    0b00000011 3
                ora $dd00   ;   765432[10] %11, 3 Bank #0, $0000-$3FFF, 0-16383.
                sta $dd00   ;   Bits #0-#1 VIC bank. Values

                lda # ( $0400 / 256 ) 
                sta c64.SCRPTR
                
                rts
                
            ; ....................................................  graph default
            ;            
            ;   text mode , hires off , multicolor off
            ;

            bitmap_E000_screen_CC00_OFF

                            ;             76543210
                lda #$ef    ;   0xef    0b11101111
                and $d016   ;   Bit #4 0 = Multicolor mode off..
                sta $d016   ; Screen control register #2. Bits    
                
                jsr bitmap_E000_screen_CC00_graf_OFF
                
                rts

            ;   utility 
            
            high    .proc
                on  .proc
                    jsr hires_bitmap_E000_screen_CC00_ON
                    rts
                .pend
                off .proc
                    jsr bitmap_E000_screen_CC00_OFF
                    rts
                .pend
            .pend
            low    .proc
                on  .proc
                    jsr multi_bitmap_E000_screen_CC00_ON
                    rts
                .pend
                off .proc
                    jsr bitmap_E000_screen_CC00_OFF
                    rts
                .pend
            .pend

        .pend

        ;   ....................................................   graph default
        ;
        ;   set bank 0 , bitmap 2000 , screen 0400
        ;
        
        bank0   .proc
        
            bitmap_2000_screen_0400_graf_ON    .proc
                jsr bitmap_E000_screen_CC00_OFF
                rts
            .pend
            
        .pend
    
        default .proc
                jsr bitmap_E000_screen_CC00_OFF
                rts
        .pend
        
        ;
        ;
        ;

.pend

;;;
;;
;
