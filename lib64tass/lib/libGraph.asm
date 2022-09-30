
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
        ;   c000  49152 (2048)    //        2k
        ;   c800  51200 (1024)    screen    1k
        ;   cc00  52224 (256)     //        0,5k
        ;   cd00        (256)     //
        ;   ce00        (256)     stack hi  0,5k
        ;   cf00        (256)     stack lo
        
        ; ------------------------------------------------- 
        
        max_x   = 320
        max_y   = 200
        
        ; ------------------------------------------------- 
        
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
        
        clear .proc

            ;lda  #<bitmap_addr
            lda  #$00
            sta  zpWord0
            ;lda  #>bitmap_addr
            lda  #$20
            sta  zpWord0+1
            
            ldy  #<8000
            ldx  #>8000
            lda  #0
            
            jsr  mem.set_byte
            rts            

        .pend

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
    
    tbl_8       :=  range(0, 41, 1) * 8 

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
