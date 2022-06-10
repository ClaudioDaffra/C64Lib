
chrget  =       $0073
chrgot  =       $0079
ieval   =       $030a   ;       Execution address of routine reading next 
                        ;       item of BASIC expression. ( AE86 )

*= $c000

        lda #<cdBasicEvalHex:
        sta ieval
        lda #>cdBasicEvalHex:
        sta ieval+1
        rts

cdBasicEvalHex:

        lda     #0      ;       00      number  ff      string
        sta     $0d     ;       tell    basic this is a number

        jsr     chrget
        cmp     #"$"

        beq     cdBasicIsHex:

        jsr     chrgot
        jmp     $ae8d   ;       next statement


cdBasicIsHex:

        lda     #0
        sta     $fe     ;       hi
        sta     $fd     ;       lo
        sta     $fc     ;       hi
        sta     $fb     ;       lo


        ldx     #$04    
cdBasicIsHexLoop:

        jsr     chrget

        ;       If the C flag is 0, then A (unsigned) < NUM (unsigned) and BCC
        ;       will branch
        ;       If the C flag is 1, then A (unsigned) >= NUM (unsigned) and BCS 
        ;       will branch


        cmp     #"@"
        beq     cdBasicIsHexLoopEnd:       

        cmp     #71            ;      > F
        bcs     cdBasicIsHexLoopEnd:       ;      c=1 >= numero non esadecimale

        cmp     #47            ;      < 0
        bcc     cdBasicIsHexLoopEnd:       ;      c=1 < numero non esadecimale
 
        cmp     #65             ;        
        bcs     cdBasicIsDigitAF:      ;     c=  >=   

        sbc     #47             ;       
        sta     $fa,x

        jmp cdBasicIsCheckEndLoop:

cdBasicIsDigitAF:

        sbc     #55             ;   65-10    A=10
        sta     $fa,x

cdBasicIsCheckEndLoop:

        dex
        beq    cdBasicIsHexLoopEnd: 

        jmp cdBasicIsHexLoop:


cdBasicIsHexLoopEnd:

        ;               ;       $D021
        ;       $fe     ;       hi      D       HI      $62
        ;       $fd     ;       lo      0
        ;       $fc     ;       hi      2       LO      $63
        ;       $fb     ;       lo      1

        ;       $62     ;       HI
        ;       $63     ;       LO


        lda $fe         ;       shift hi     0000xxxx <- xxxx0000
        asl
        asl
        asl
        asl
        sta $fe

        lda $fc         ;       shift hi    0000xxxx <- xxxx0000
        asl
        asl
        asl
        asl
        sta $fc

        lda $fd         ;       memorizza nibble in $62:$63
        ora $fe
        sta $62

        lda $fb
        ora $fc
        sta $63


        ldx     #$90    ;       2^16

        sec

        jsr $bc49       ;       convert 16 bits int/float

        jmp chrget      ;       get next char and exit





