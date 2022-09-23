


;--------------------------------------------------------------- string

string .proc

    ; TODO
    
    ;  screen   :    1024   -    2023
    ;               $0400   -   $07E7
    ;  buffer   :    2024   -    2048    (24)
    ;               $07E8   -   $0800
    ;
    ;   program :    2049   -  $0801

    temp =   $07e8   ;   (24) byte

    ;--------------------------------------------------------------- length
    ;   input   :   a/y :   address string
    ;   output  :   a   :   length
    
    length    .proc
        
            sta  zpWord0
            sty  zpWord0+1
            ldy  #0
    -        
            lda  (zpWord0),y
            beq  +
            iny
            bne  -
    +       
            tya
            rts
            
    .pend

    ;--------------------------------------------------------------- left
    ;   input   :   
    ;              address string zpWord0 source
    ;              address string zpWord1 dest
    ;              a   left
    ;   output  :  //
    
    left    .proc

            ;   zpWord0 source
            ;   zpWord1 dest
            
            tay
            lda  #0
            sta  (zpWord1),y
            cpy  #0
            bne  _loop
            rts
    _loop        
            dey
            lda  (zpWord0),y
            sta  (zpWord1),y
            cpy  #0
            bne  _loop
    +        
        rts
    
    .pend

    ;--------------------------------------------------------------- right
    ;   input   :   
    ;              address string zpWord0 source
    ;              address string zpWord1 dest
    ;              a   right
    ;   output  :  //
    
    right    .proc

            sta  zpy
            lda  zpWord0
            ldy  zpWord0+1
            jsr  string.length
            tya
            sec
            sbc  zpy
            clc
            adc  zpWord0
            sta  zpWord0
            lda  zpWord0+1
            adc  #0
            sta  zpWord0+1
            ldy  zpWord1
            sty  zpWord1
            ldy  zpWord1+1
            sty  zpWord1+1
            ldy  zpy
            lda  #0
            sta  (zpWord1),y
            cpy  #0
            bne  _loop
            rts
    _loop        
            dey
            lda  (zpWord0),y
            sta  (zpWord1),y
            cpy  #0
            bne  _loop
    +       
            rts
    .pend

    ;--------------------------------------------------------------- mid
    ;   input   :   
    ;              address string zpWord0 source
    ;              address string zpWord1 dest
    ;              a    start
    ;              y    length
    ;   output  :  //
    
    mid    .proc
            ; sub string (source, dest , start, length )
            ;   a   #2      ;   partenza
            ;   y   #3      ;   lunghezza
            
            sta  zpy
            
            lda  zpWord0
            sta  zpWord0
            lda  zpWord0+1
            sta  zpWord0+1
            
            lda  zpWord1
            sta  zpWord1
            lda  zpWord1+1
            sta  zpWord1+1
            ; adjust src location
            clc
            lda  zpWord0
            adc  zpy
            sta  zpWord0
            bcc  +
            inc  zpWord0+1
    +        
            lda  #0
            sta  (zpWord1),y
            beq  _startloop
    -        
            lda  (zpWord0),y
            sta  (zpWord1),y
    _startloop   
            dey
            cpy  #$ff
            bne  -
            
            rts
        .pend

    ;--------------------------------------------------------------- find char
    ;   input   :   
    ;              address string zpWord0 source
    ;              a    char
    ;   output  :
    ;               (C=1)   found
    ;               (c=0)   not found
    
    find_char    .proc
            sta  zpy
            lda  zpWord0
            ldy  zpWord0+1
            sta  zpWord0
            sty  zpWord0+1
            ldy  #0
    -        
            lda  (zpWord0),y
            beq  _notfound
            cmp  zpy
            beq  _found
            iny
            bne  -
    _notfound    
            lda  #0
            clc
            rts
    _found        
            tya
            sec
            rts
    .pend

    ;--------------------------------------------------------------- copy
    ;   input   :   
    ;              address string zpWord0 source
    ;              address string zpWord1 dest
    ;   output  :
    ;              a length string copied
    ;
    ;  zpWord1 = zpWord0
    ;
    
    copy        .proc
        ; copy a string (must be 0-terminated) from A/Y to (zpWord0)
        ; it is assumed the target string is large enough.
        ; returns the length of the string that was copied in Y.

        ldy  #$ff
-        
        iny
        lda  (zpWord1),y
        sta  (zpWord0),y
        bne  -
        tya
        rts
        
    .pend

    ;--------------------------------------------------------------- copy
    ;   input   :   
    ;              address string zpWord0 source
    ;              address string zpWord1 dest
    ;   output  :
    ;              -1,0,1 in A, depeding on the ordering.

    compare    .proc
    
            ldy  #0
    _loop        
            lda  (zpWord0),y
            bne  +
            lda  (zpWord1),y
            bne  _return_minusone
            beq  _return
    +        
            cmp  (zpWord1),y
            bcc  _return_minusone
            bne  _return_one
            inc  zpWord0
            bne  +
            inc  zpWord0+1
    +        
            inc  zpWord1
            bne  _loop
            inc  zpWord1+1
            bne  _loop
    _return_one
            lda  #1
    _return        
            rts
    _return_minusone
            lda  #-1
            rts
    .pend
    
    
;    
    
    
.pend


;;;
;;
;


