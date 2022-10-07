
;--------------------------------------------------------------- conv

conv .proc

    ; PETSCII:"????????????????"    16+1
    
    string_out    
        .byte  $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
        .byte  $00


    ;--------------------------------------------------------------- u8_to_hex
    ;
	; convert byte in digit
    ;
	; input : 
    ;           a   byte
	; output:
    ;           a,y digit
	
	u8_to_hex

			stx  zpx
			pha
			and  #$0f
			tax
			ldy  global.hex_digits,x
			pla
			lsr  a
			lsr  a
			lsr  a
			lsr  a
			tax
			lda  global.hex_digits,x
			ldx  zpx
            
			rts
            
    ;--------------------------------------------------------------- str_ub0
    ;
	; input : 
    ;           a   unsigned byte
	; output:
    ;           conv.string_out
    
    str_ub0    .proc
            stx  zpx
            jsr  conv.ubyte2decimal
            sty  string_out
            sta  string_out+1
            stx  string_out+2
            lda  #0
            sta  string_out+3
            ldx  zpx
            rts
    .pend

    ;--------------------------------------------------------------- str_ub
    ;
	; input : 
    ;           a   unsigned byte
	; output:
    ;           conv.string_out
    
    str_ub    .proc
     
            stx  zpx
            ldy  #0
            sty  zpy
            jsr  conv.ubyte2decimal
    _output_byte_digits
            ; hundreds?
            cpy  #'0'
            beq  +
            pha
            tya
            ldy  zpy
            sta  string_out,y
            pla
            inc  zpy
            ; tens?
    +        
            ldy  zpy
            cmp  #'0'
            beq  +
            sta  string_out,y
            iny
    +       ; ones.
            txa
            sta  string_out,y
            iny
            lda  #0
            sta  string_out,y
            ldx  zpx
            rts
        .pend

    ;--------------------------------------------------------------- str_b
    ;
	; input : 
    ;           a   signed byte
	; output:
    ;           conv.string_out
    
    str_b    .proc

            stx  zpx
            ldy  #0
            sty  zpy
            cmp  #0
            bpl  +
            pha
            lda  #'-'
            sta  string_out
            inc  zpy
            pla
    +           
            jsr  conv.byte2decimal
            ;   There's a pseudo opcode called GRA for CPUs supporting BRA, 
            ;   which is expanded to BRL (if available) or JMP
            ;   bra  str_ub._output_byte_digits
            jmp  str_ub._output_byte_digits
    .pend

    ;--------------------------------------------------------------- str_ubhex
    ;
	; input : 
    ;           a   unsigned byte
	; output:
    ;           conv.string_out
    
    str_ubhex    .proc
    
            jsr  conv.ubyte2hex
            sta  string_out
            sty  string_out+1
            lda  #0
            sta  string_out+2
            rts
            
    .pend

    ;--------------------------------------------------------------- str_ubbin
    ;
	; input : 
    ;           a   unsigned byte
	; output:
    ;           conv.string_out
    
    str_ubbin    .proc

            sta  zpy
            ldy  #0
            sty  string_out+8
            ldy  #7
    -        
            lsr  zpy
            bcc  +
            lda  #'1'
            bne  _digit
    +           
            lda  #'0'
    _digit      
            sta  string_out,y
            dey
            bpl  -
            
            rts
    .pend
    
    ;--------------------------------------------------------------- str_uwbin
    ;--------------------------------------------------------------- str_uwhex
    ;--------------------------------------------------------------- str_uwdec0
    ;--------------------------------------------------------------- str_uwdec
    ;--------------------------------------------------------------- str_w
    ;
	; input : 
    ;           ay   unsigned word
	; output:
    ;           conv.string_out
    
    str_uwbin    .proc

            sta  zpx
            tya
            jsr  str_ubbin
            ldy  #0
            sty  string_out+16
            ldy  #7
    -        
            lsr  zpx
            bcc  +
            lda  #'1'
            bne  _digit
    +           
            lda  #'0'
    _digit      
            sta  string_out+8,y
            dey
            bpl  -
            rts
        .pend

    str_uwhex    .proc
     
            pha
            tya
            jsr  conv.ubyte2hex
            sta  string_out
            sty  string_out+1
            pla
            jsr  conv.ubyte2hex
            sta  string_out+2
            sty  string_out+3
            lda  #0
            sta  string_out+4
            rts
    .pend

    str_uwdec0    .proc
     
            stx  zpx
            jsr  conv.uword2decimal
            ldy  #0
    -           
            lda  conv.uword2decimal.decTenThousands,y
            sta  string_out,y
            beq  +
            iny
            bne  -
    +           
            ldx  zpx
            rts
            
    .pend

    str_uwdec    .proc
     
            stx  zpx
            jsr  conv.uword2decimal
            ldx  #0
    _output_digits
            ldy  #0
    -           
            lda  conv.uword2decimal.decTenThousands,y
            beq  _allzero
            cmp  #'0'
            bne  _gotdigit
            iny
            bne  -
    _gotdigit   
            sta  string_out,x
            inx
            iny
            lda  conv.uword2decimal.decTenThousands,y
            bne  _gotdigit
    _end        
            lda  #0
            sta  string_out,x
            ldx  zpx
            rts
    _allzero    
            lda  #'0'
            sta  string_out,x
            inx
            bne  _end
            
    .pend

    str_w    .proc
     
            cpy  #0
            bpl   str_uwdec
            stx  zpx
            pha
            lda  #'-'
            sta  string_out
            tya
            eor  #255
            tay
            pla
            eor  #255
            clc
            adc  #1
            bcc  +
            iny
    +        
            jsr  conv.uword2decimal
            ldx  #1
            bne  str_uwdec._output_digits
     
            rts
            
    .pend
    
    ;--------------------------------------------------------------- ubyte2hex
    ;--------------------------------------------------------------- uword2hex
    ;
	; input : 
    ;           a   unsigned byte
	; output:
    ;           conv.string_out
    
    ubyte2hex    .proc
     
            stx  zpx
            pha
            and  #$0f
            tax
            ldy  global.hex_digits,x
            pla
            lsr  a
            lsr  a
            lsr  a
            lsr  a
            tax
            lda  global.hex_digits,x
            ldx  zpx
            rts

    .pend

    uword2hex    .proc
 
            sta  zpx
            tya
            jsr  ubyte2hex
            sta  output
            sty  output+1
            lda  zpx
            jsr  ubyte2hex
            sta  output+2
            sty  output+3
            rts
            
    output        .text  "0000", $00      ; 0-terminated output buffer (to make printing easier)
    
    .pend
    

    ;--------------------------------------------------------------- ubyte2decimal
    
    ubyte2decimal    .proc
            ldy  #uword2decimal.ASCII_0_OFFSET
            bne  uword2decimal.hex_try200
            rts
    .pend

    ;--------------------------------------------------------------- uword2decimal
    
    uword2decimal    .proc

        ;Convert 16 bit Hex to Decimal (0-65535) Rev 2
        ;By Omegamatrix    Further optimizations by tepples
        ; routine from https://forums.nesdev.org/viewtopic.php?f=2&t=11341&start=15

        ;HexToDec99
        ; start in A
        ; end with A = 10's, decOnes (also in X)

        ;HexToDec255
        ; start in A
        ; end with Y = 100's, A = 10's, decOnes (also in X)

        ;HexToDec999
        ; start with A = high byte, Y = low byte
        ; end with Y = 100's, A = 10's, decOnes (also in X)
        ; requires 1 extra temp register on top of decOnes, could combine
        ; these two if HexToDec65535 was eliminated...

        ;HexToDec65535
        ; start with A/Y (low/high) as 16 bit value
        ; end with decTenThousand, decThousand, Y = 100's, A = 10's, decOnes (also in X)
        ; (irmen: I store Y and A in decHundreds and decTens too, so all of it can be easily printed)

        ASCII_0_OFFSET     = $30
        temp               = zpy            ; byte in zeropage
        hexHigh            = zpWord0        ; byte in zeropage
        hexLow             = zpWord0+1      ; byte in zeropage

        ; SUBROUTINE
        HexToDec65535   
        
            sty    hexHigh 
            sta    hexLow 
            tya
            tax 
            lsr    a 
            lsr    a                     ;  integer divide 1024 (result 0-63)

            cpx    #$A7                  ;  account for overflow of multiplying 24 from 43,000 ($A7F8) onward,
            adc    #1                    ;  we can just round it to $A700, and the divide by 1024 is fine...

            ;at this point we have a number 1-65 that we have to times by 24,
            ;add to original sum, and Mod 1024 to get a remainder 0-999
         
            sta    temp 
            asl    a 
            adc    temp 
            tay 
            lsr    a 
            lsr    a 
            lsr    a 
            lsr    a 
            lsr    a 
            tax 
            tya 
            asl    a 
            asl    a 
            asl    a 
            clc  
            adc    hexLow 
            sta    hexLow 
            txa 
            adc    hexHigh 
            sta    hexHigh 
            ror    a 
            lsr    a 
            tay                          ;  integer divide 1,000 (result 0-65)

            lsr    a                     ;  split the 1,000 and 10,000 digit
            tax 
            lda    ShiftedBcdTab,x 
            tax 
            rol    a 
            and    #$0F 
            ora    #ASCII_0_OFFSET
            sta    decThousands 
            txa 
            lsr    a 
            lsr    a 
            lsr    a 
            ora    #ASCII_0_OFFSET
            sta    decTenThousands 

            lda    hexLow 
            cpy    temp 
            bmi    _doSubtract 
            beq    _useZero 
            adc    #23 + 24 
        _doSubtract
            sbc    #23 
            sta    hexLow 
        _useZero
            lda    hexHigh 
            sbc    #0 

        Start100s
            and    #$03 
            tax                          ;  0,1,2,3
            cmp    #2 
            rol    a                     ;  0,2,5,7
            ora    #ASCII_0_OFFSET
            tay                          ;  Y = Hundreds digit

            lda    hexLow 
            adc    Mod100Tab,x           ;  adding remainder of 256, 512, and 256+512 (all mod 100)
            bcs    hex_doSub200 

        hex_try200
            cmp    #200 
            bcc    hex_try100 
        hex_doSub200
            iny 
            iny 
            sbc    #200 
        hex_try100
            cmp    #100 
            bcc    HexToDec99 
            iny 
            sbc    #100 

        HexToDec99; SUBROUTINE
            lsr    a 
            tax 
            lda    ShiftedBcdTab,x 
            tax 
            rol    a 
            and    #$0F 
            ora    #ASCII_0_OFFSET
            sta    decOnes 
            txa 
            lsr    a 
            lsr    a 
            lsr    a  
            ora    #ASCII_0_OFFSET
            ; irmen: load X with ones, and store Y and A too, for easy printing afterwards
            sty  decHundreds
            sta  decTens
            ldx  decOnes
            rts                          ;  Y=hundreds, A = tens digit, X=ones digit


        HexToDec999; SUBROUTINE
            sty    hexLow 
            jmp    Start100s 

        Mod100Tab
            .byte 0,56,12,56+12

        ShiftedBcdTab
            .byte $00,$01,$02,$03,$04,$08,$09,$0A,$0B,$0C
            .byte $10,$11,$12,$13,$14,$18,$19,$1A,$1B,$1C
            .byte $20,$21,$22,$23,$24,$28,$29,$2A,$2B,$2C
            .byte $30,$31,$32,$33,$34,$38,$39,$3A,$3B,$3C
            .byte $40,$41,$42,$43,$44,$48,$49,$4A,$4B,$4C

        decTenThousands         .byte  0
        decThousands            .byte  0
        decHundreds             .byte  0
        decTens                 .byte  0
        decOnes                 .byte  0
                                .byte  0        ; zero-terminate the decimal output string
    .pend
 
    byte2decimal    .proc
      
            cmp  #0
            bpl  +
            eor  #255
            clc
            adc  #1
    +        
            jmp  ubyte2decimal
            
    .pend
    
    ;--------------------------------------------------------------- any2uword
    ;
    ;   convert :   decimal $hex %binary - number to word
    ;
	; input : 
    ;           ay  address string
	; output:
    ;           zpWord0
    ;
    ;--------------------------------------------------------------- 
    ;
    ;                                                               conv.str2uword
    ;                                                               conv.bin2uword
    ;                                                               conv.hex2uword
    ;
	; input : 
    ;           ay  address string
	; output:
    ;           zpWord0
    ;

    any2uword	.proc
     
        pha
        sta  zpWord0
        sty  zpWord0+1
        ldy  #0
        lda  (zpWord0),y
        ldy  zpWord0+1
        cmp  #'$'
        beq  _hex
        cmp  #'%'
        beq  _bin
        pla
        jsr  str2uword
        jmp  _result
    _hex
        pla
        jsr  hex2uword
        jmp  _result
    _bin
        pla
        jsr  bin2uword
    _result
        pha
        lda  zpWord2
        sta  zpa        ; result value
        pla
        sta  zpWord2
        sty  zpWord2+1
        lda  zpa
        rts
        
    .pend
    
    ;--------------------------------------------------------------- str2uword
    
    str2uword	.proc
         
    _result = zpWord0
    
            sta  zpWord1
            sty  zpWord1+1
            ldy  #0
            sty  _result
            sty  _result+1
            sty  zpWord2+1
    _loop
            lda  (zpWord1),y
            sec
            sbc  #48
            bpl  _digit
    _done
            sty  zpWord2
            lda  _result
            ldy  _result+1
            rts
    _digit
            cmp  #10
            bcs  _done
            ; add digit to result
            pha
            jsr  _result_times_10
            pla
            clc
            adc  _result
            sta  _result
            bcc  +
            inc  _result+1
    +
            iny
            bne  _loop
            ; never reached
    _result_times_10     ; (W*4 + W)*2
            lda  _result+1
            sta  zpa
            lda  _result
            asl  a
            rol  zpa
            asl  a
            rol  zpa
            clc
            adc  _result
            sta  _result
            lda  zpa
            adc  _result+1
            asl  _result
            rol  a
            sta  _result+1
            rts
    .pend
    
    ;--------------------------------------------------------------- hex2uword
    
    hex2uword	.proc
     
        sta  zpWord1
        sty  zpWord1+1
        ldy  #0
        sty  zpWord0
        sty  zpWord0+1
        sty  zpWord2+1
        lda  (zpWord1),y
        beq  _stop
        cmp  #'$'
        bne  _loop
        iny
    _loop
        lda  #0
        sta  zpa
        lda  (zpWord1),y
        beq  _stop
        cmp  #7             ; screencode letters A-F are 1-6
        bcc  _add_letter
        and  #127
        cmp  #97
        bcs  _try_iso       ; maybe letter is iso:'a'-iso:'f' (97-102)
        cmp  #'g'
        bcs  _stop
        cmp  #'a'
        bcs  _add_letter
        cmp  #'0'
        bcc  _stop
        cmp  #'9'+1
        bcs  _stop
    _calc
        asl  zpWord0
        rol  zpWord0+1
        asl  zpWord0
        rol  zpWord0+1
        asl  zpWord0
        rol  zpWord0+1
        asl  zpWord0
        rol  zpWord0+1
        and  #$0f
        clc
        adc  zpa
        ora  zpWord0
        sta  zpWord0
        iny
        bne  _loop
    _stop
        sty  zpWord2
        lda  zpWord0
        ldy  zpWord0+1
        rts
    _add_letter
        pha
        lda  #9
        sta  zpa
        pla
        jmp  _calc
    _try_iso
        cmp  #103
        bcs  _stop
        and  #63
        bne  _add_letter
    .pend
    
    ;--------------------------------------------------------------- bin2uword
    
    bin2uword	.proc
     
        sta  zpWord1
        sty  zpWord1+1
        ldy  #0
        sty  zpWord0
        sty  zpWord0+1
        sty  zpWord2+1
        lda  (zpWord1),y
        beq  _stop
        cmp  #'%'
        bne  _loop
        iny
    _loop
        lda  (zpWord1),y
        cmp  #'0'
        bcc  _stop
        cmp  #'2'
        bcs  _stop
    _first  asl  zpWord0
        rol  zpWord0+1
        and  #1
        ora  zpWord0
        sta  zpWord0
        iny
        bne  _loop
    _stop
        sty  zpWord2
        lda  zpWord0
        ldy  zpWord0+1
        rts
        
    .pend
    
    ;--------------------------------------------------------------- str2word
    ;
    ;   convert :   decimal number to word
    ;
	; input : 
    ;           ay  address string
	; output:
    ;           zpWord0
    ;

    str2word	.proc

            _result = zpWord0
    
            sta  zpWord1
            sty  zpWord1+1
            ldy  #0
            sty  _result
            sty  _result+1
            sty  _negative
            sty  zpWord2+1
            lda  (zpWord1),y
            cmp  #'+'
            bne  +
            iny
    +
            cmp  #'-'
            bne  _parse
            inc  _negative
            iny
    _parse
            lda  (zpWord1),y
            sec
            sbc  #48
            bpl  _digit
    _done
            sty  zpWord2
            lda  _negative
            beq  +
            sec
            lda  #0
            sbc  _result
            sta  _result
            lda  #0
            sbc  _result+1
            sta  _result+1
    +
            lda  _result
            ldy  _result+1
            rts
    _digit
            cmp  #10
            bcs  _done
            ; add digit to result
            pha
            jsr  str2uword._result_times_10
            pla
            clc
            adc  _result
            sta  _result
            bcc  +
            inc  _result+1
    +		
            iny
            bne  _parse
            ; never reached
    _negative	.byte  0
    
    .pend

    ;   ................................................. byte_to_word
    ;
    ;       signed 8 ext to     signed 16
    ;     unsigned 8 ext to   unsigned 16
    ;
    
    byte_to_word .proc   

        sta zpWord0
        lda #$7f
        cmp zpWord0
        sbc #$7f
        sta zpWord0+1
        rts

    .pend

    ubyte_to_uword .proc   

        sta zpWord0
        lda #0
        sta zpword0+1
        rts

    .pend
    
.pend

;;;
;;
;
