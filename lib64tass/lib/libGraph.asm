
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
        ;   c800  51200 (1024)     screen   1k
        ;   cc00  52224 (256)     //        0,5k
        ;   cd00        (256)     //
        ;   ce00        (256)     stack hi  0,5k
        ;   cf00        (256)     stack lo
        
        ; ------------------------------------------------- 

        hires_on    .proc   ;   0400
            jsr c64.set_bitmap_mode_320x200_on
            jsr c64.set_screen_0400_bitmap_2000_addr
            rts
        .pend

        hires_off    .proc   ;   0400
            jsr c64.set_bitmap_mode_320x200_off
            jsr c64.set_screen_0400_bitmap_2000_addr
            rts
        .pend

        lores_on    .proc   ;   0400
            jsr c64.set_bitmap_mode_160x200_on
            jsr c64.set_screen_0400_bitmap_2000_addr
            rts
        .pend

        lores_off    .proc   ;   0400
            jsr c64.set_bitmap_mode_160x200_off
            jsr c64.set_screen_0400_bitmap_2000_addr
            rts
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

        hires_color .proc   ;   a:background    y:foreground
        
            lda screen.foreground_color
            sta screen.background_color_2
            
            lda screen.background_color
            sta screen.background_color_3
            
            jsr txt.set_char_with_col_2_3
            
            jsr txt.clear_screen_chars 
            
            rts
         .pend

.pend

;;;
;;
;
