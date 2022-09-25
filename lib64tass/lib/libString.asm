


;--------------------------------------------------------------- string

string .proc

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
       
    ;--------------------------------------------------------------- upper / lower
    ;   input   :   
    ;              address string zpWord0 source
    ;   output  :   
    ;              address string zpWord0 dest
    
    lower    .proc
         
                sta  zpWord0
                sty  zpWord0+1
                ldy  #0
    -           lda  (zpWord0),y
                beq  _done
                and  #$7f
                cmp  #97
                bcc  +
                cmp  #123
                bcs  +
                and  #%11011111
    +           sta  (zpWord0),y
                iny
                bne  -
    _done       
                rts
        .pend

    upper    .proc
     
                sta  zpWord0
                sty  zpWord0+1
                ldy  #0
    -           lda  (zpWord0),y
                beq  _done
                cmp  #65
                bcc  +
                cmp  #91
                bcs  +
                ora  #%00100000
    +           sta  (zpWord0),y
                iny
                bne  -
    _done       
                rts
    .pend

    ;----------------------------------------- pattern matching of a string.
    ;
    ; Input:  
    ;           zpWord0  :  string
    ;           zpWord1  :  pattern matching
    ;
    ; Output: 
    ;           A = 1 if the string matches the pattern, A = 0 if not.
    ;           (C) = 1 found   ,   (C) = 0 not found

    pattern_match_internal    .proc
    
        stx  zpx
        lda  zpWord1
        sta  modify_pattern1+1
        sta  modify_pattern2+1
        lda  zpWord1+1
        sta  modify_pattern1+2
        sta  modify_pattern2+2
        jsr  _match
        lda  #0
        adc  #0
        ldx  zpx
        rts
    _match
        ldx #$00        ; x is an index in the pattern
        ldy #$ff        ; y is an index in the string
    modify_pattern1
    next    
        lda $ffff,x     ; look at next pattern character    MODIFIED
        cmp #'*'        ; is it a star?
        beq star        ; yes, do the complicated stuff
        iny             ; no, let's look at the string
        cmp #'?'        ; is the pattern caracter a ques?
        bne reg         ; no, it's a regular character
        lda (zpWord0),y ; yes, so it will match anything
        beq fail        ;  except the end of string
    reg     
        cmp (zpWord0),y ; are both characters the same?
        bne fail        ; no, so no match
        inx             ; yes, keep checking
        cmp #0          ; are we at end of string?
        bne next        ; not yet, loop
    found
        rts             ; success, return with c=1
    star    
        inx             ; skip star in pattern
    modify_pattern2
        cmp $ffff,x     ; string of stars equals one star    MODIFIED
        beq star        ; so skip them also
    stloop  
        txa             ; we first try to match with * = ""
        pha             ; and grow it by 1 character every
        tya             ; time we loop
        pha             ; save x and y on stack
        jsr next        ; recursive call
        pla             ; restore x and y
        tay
        pla
        tax
        bcs found       ; we found a match, return with c=1
        iny             ; no match yet, try to grow * string
        lda (zpWord0),y ; are we at the end of string?
        bne stloop      ; not yet, add a character
    fail    
        clc             ; yes, no match found, return with c=0
        rts

    .pend

    pattern_match    .proc
    
                jsr pattern_match_internal
                cmp #0
                bne uno
          zero
                clc
                rts
          uno
                sec
                rts
    .pend
;    
    
    
.pend


;;;
;;
;


