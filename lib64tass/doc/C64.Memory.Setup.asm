
; ---------------------------------------------------------- Port A

$DD02 56578 Port A data direction register.

    Bit #x: 0 = Bit #x in port A can only be read; 
            1 = Bit #x in port A can      be read and written.

    ->  poke 56578,peek(56578) or 3

; ---------------------------------------------------------- VIC bank

    $DD00 56576 7654:3210   
                1001:0111   (151)   default
                ....:..xx
                    
    Bits #0-#1: VIC bank. Values:

    %00, 0: Bank #3, $C000-$FFFF, 49152 -   65535.
    %01, 1: Bank #2, $8000-$BFFF, 32768 -   49151.
    %10, 2: Bank #1, $4000-$7FFF, 16384 -   32767.
    %11, 3: Bank #0, $0000-$3FFF, 0     -   16383.  default (xx)

    -> poke 56576,(peek(56576)and 252) or (bank)

; ---------------------------------------------------------- Memory setup register

    $D018   53272   
    
    7654:3210
    0001:0101 (21)  default
    ....:....
    SSSS:....        SSSSS  := SCREEN       %0001, 1: $0400-$07FF, 1024- 2047.
          B          B      := BITMAP       %x1xx, 4: $2000-$3FFF, 8192-16383.
    ....:.CCC        CCC    := CHARACTER    %x100, 4: $2000-$27FF, 8192-10239.

    BITMAP OFFSET

        %0xx, 0: $0000-$1FFF, 0     - 8191.
        %1xx, 4: $2000-$3FFF, 8192  -16383.

    SCREEN OFFSET

        %0000,  0: $0000-$03FF, 0-1023.
        %0001,  1: $0400-$07FF, 1024-2047.
        %0010,  2: $0800-$0BFF, 2048-3071.
        %0011,  3: $0C00-$0FFF, 3072-4095.
        %0100,  4: $1000-$13FF, 4096-5119.
        %0101,  5: $1400-$17FF, 5120-6143.
        %0110,  6: $1800-$1BFF, 6144-7167.
        %0111,  7: $1C00-$1FFF, 7168-8191.
        %1000,  8: $2000-$23FF, 8192-9215.
        %1001,  9: $2400-$27FF, 9216-10239.
        %1010, 10: $2800-$2BFF, 10240-11263.
        %1011, 11: $2C00-$2FFF, 11264-12287.
        %1100, 12: $3000-$33FF, 12288-13311.
        %1101, 13: $3400-$37FF, 13312-14335.
        %1110, 14: $3800-$3BFF, 14336-15359.
        %1111, 15: $3C00-$3FFF, 15360-16383.

; ---------------------------------------------------------- pointer screen location

$0288 648   High byte of pointer to screen memory for screen input/output.
            Default: $04, $0400, 1024.
            4*256  = bank+1024

; ---------------------------------------------------------- 

BASIC EXAMPLE

        0  printchr$(147)
        5  rem Bit #x: 0 = Bit #x in port A can only be read; 
        6  rem = Bit #x in port A can be read and written.
        7  rem
        10 poke 56578,peek(56578) or 3
        15 rem
        18 rem select bank
        19 rem 
        20 poke 56576,(peek(56576)and 252) or 1 : rem 32768
        21 rem
        25 rem  memory setup    [0000]:0[1]00
        26 rem  bitmap      1   1  $2000
        27 rem  screen  0000    0: $0000-$03FF, 0-1023.
        28 rem
        30 poke 53272,4
        35
        40 poke 648,128
        45
        45 printchr$(147)
        50 rem
        60 poke 32768,4 : rem scrive un carattere

        set directional flag
        
            10 poke 56578,peek(56578) or 3
        
        set screen
        
            poke 56576,peek(57576) and 00001111
            lda asl asl asl
            poke 56576,peek(57576) or  xxxx0000

        set bitmap
        
            poke 53272,peek(53272) and 11111011
            poke 53272,peek(53272) or  00000100  / 00000000

        set pointer screen
        
            poke 648, ( bank + screen offset ) / 256
            