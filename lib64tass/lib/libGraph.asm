
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
        
        clear_old_style .proc

            lda	#$00 	;	00
            sta	$f9        
            lda	#$20	;	E0	load pointer bitmap $e000	( bank4 $c000 + $2000 ) 
            sta	$fa		            
            
            ldx #$20
            
            lda #$00            
            tay

    _gclear_loop:			;	clear bitmap	*($f9/$fa) = 0	[00e0]
            
            sta ($f9),y
            iny
            bne	_gclear_loop
            inc $fa
            dex
            bne	_gclear_loop
            
            rts
        
        .pend


.pend

;;;
;;
;
