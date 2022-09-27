
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
        
        start .proc

            ;   screen 0800
            ;   bitmap 2000
            lda #%00100101
            sta 53272
            rts
            
        .pend

        stop .proc
        
            ;   screen 0400
            ;   bitmap 2000
            lda #%00010101
            sta 53272
            rts
            
        .pend
        
.pend

;;;
;;
;
