
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
        
        ; -------------------------------------------------     clear
        
        clear .proc

            lda  #<c64.bitmap_addr
            sta  zpWord0
            
            lda  #>c64.bitmap_addr
            sta  zpWord0+1
            
            ldy  #<8000
            ldx  #>8000
            lda  #0
            jsr  mem.set_byte
            
            rts            

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
                    ;jsr _graphIntRomDisable
                    .endif
                    
                    lda (P),y           ;   get row with point in it
                    ora tbl_orbit,x     ;   isolate and set the point
                    sta (P),y           ;   write back to _graphBitMap

                    jmp past            ;   skip the erase-point section

                ;..................     unset point

                    erase:              ;   handled same way as setting a point

                    lda (P),y           ;   just with opposite bit-mask
                    and tbl_andbit,x    ;   isolate and erase the point
                    sta (P),y           ;   write back to _graphBitMap

                    past:
                    
                    .if c64.bitmap_addr == $E000
                    ;jsr _graphIntRomEnable
                    .endif
                
                rts
                
                ;................................................................   _plotPointMC
                
        plotPointMC

                    .if c64.bitmap_addr == $E000
                    ;jsr _graphIntRomDisable
                    .endif
                    
                    lda (P),y                   ;erase couple of bit 
                    and tblMC_andbitbit,x  
                    sta (P),y                 

                    .if c64.bitmap_addr == $E000
                    ;jsr _graphIntRomEnable
                    .endif
                    
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
                    ;jsr _graphIntRomEnable
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

                    .if c64.bitmap_addr == $E000
                    ;jsr _graphIntRomDisable
                    .endif

                    sta (P),y 

                    .if c64.bitmap_addr == $E000
                    ;jsr _graphIntRomEnable
                    .endif

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

.pend

;;;
;;
;
