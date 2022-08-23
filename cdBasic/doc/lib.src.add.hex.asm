
chrget  =       $0073
chrgot  =       $0079
ieval   =       $030a   ;       Execution address of routine reading next 
                        ;       item of BASIC expression. ( AE86 )

*= $c000

        lda #<evalhex:
        sta ieval
        lda #>evalHex:
        sta ieval+1
        rts

evalhex:

        lda     #0      ;       00      number  ff      string
        sta     $0d     ;       tell    basic this is a number

        jsr     chrget
        cmp     #"$"

        beq     ishex:

        jsr     chrgot
        jmp     $ae8d   ;       next statement


ishex:

        lda     #0
        sta     $fe     ;       hi
        sta     $fd     ;       lo
        sta     $fc     ;       hi
        sta     $fb     ;       lo


        ldx     #$04    
loop:

        jsr     chrget

        ;       If the C flag is 0, then A (unsigned) < NUM (unsigned) and BCC
        ;       will branch
        ;       If the C flag is 1, then A (unsigned) >= NUM (unsigned) and BCS 
        ;       will branch


        cmp     #"@"
        beq     loopEnd:       

        cmp     #71            ;      > F
        bcs     loopEnd:       ;      c=1 >= numero non esadecimale

        cmp     #47            ;      < 0
        bcc     loopEnd:       ;      c=1 < numero non esadecimale
 
        cmp     #65             ;        
        bcs     isDigitAF:      ;     c=  >=   

        sbc     #47             ;       
        sta     $fa,x

        jmp check:

isDigitAF:

        sbc     #55             ;   65-10    A=10
        sta     $fa,x

check:

        dex
        beq    loopEnd: 

        jmp loop:


loopEnd:

        ;               ;       $D021
        ;       $fe     ;       hi      D       HI      $62
        ;       $fd     ;       lo      0
        ;       $fc     ;       hi      2       LO      $63
        ;       $fb     ;       lo      1

        ;       $62     ;       HI
        ;       $63     ;       LO


        lda $fe         ;       shift hi
        asl
        asl
        asl
        asl
        sta $fe


        lda $fc         ;       shift hi
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




