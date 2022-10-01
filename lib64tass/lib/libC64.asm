
;**********
;           C64
;**********

.cpu  '6502'
.enc  'none'

;--------------------------------------------------------------- include

.include "libStack.asm"

;--------------------------------------------------------------- 

;******
;       global
;******

global  .proc

    hex_digits      .text '0123456789abcdef'

.pend

;**********
;           define
;**********

;---------------------------------------------------------------  bit and or

                ;76543210
                
bank3       =   %00000000
bank2       =   %00000001
bank1       =   %00000010
bank0       =   %00000011

bit_or_0    =   %00000000
bit_or_1    =   %00000010
bit_or_2    =   %00000100
bit_or_3    =   %00001000
bit_or_4    =   %00000000
bit_or_5    =   %00100000
bit_or_6    =   %01000000
bit_or_7    =   %10000000

bit_and_0    =  %11111111
bit_and_1    =  %11111101
bit_and_2    =  %11111011
bit_and_3    =  %11110111
bit_and_4    =  %11101111
bit_and_5    =  %11011111
bit_and_6    =  %10111111
bit_and_7    =  %01111111


;**********
;           zero page
;**********

;   -------------------------------------------- safe

zpa		= $02
zpx		= $2a
zpy		= $52

zpByte0 = $fb   ;   zpWord  10
zpByte1 = $fc   ;           11
zpByte2 = $fd   ;           20
zpByte3 = $fe   ;           21

zpWord0     = $fb
zpWord0hi   = $fb
zpWord0lo   = $fb+1

zpWord1     = $fd
zpWord1hi   = $fd
zpWord1lo   = $fd+1

;   -------------------------------------------- safe?

zpByte24    = $03       ;   zpWord  20
zpByte25    = $04       ;           21

zpByte36    = $05       ;           30
zpByte37    = $06       ;           31

zpWord2     = $03       ;    $B1AA, execution address of routine converting floating point to integer.
zpWord2hi   = $03
zpWord2lo   = $03+1

zpWord3     = $05       ;    $B391, execution address of routine converting integer to floating point.
zpWord3hi   = $05
zpWord3lo   = $05+1

;**********
;           temp
;**********

temp  .proc

    ;   zp
    
    buffer0023.18   =   0023    ;   (18) byte   ;   *
    ;       *
    ;       $0017-$0018 23-24	Pointer to previous expression in string stack.
    ;       $0019-$0021 25-33	String stack, temporary area for processing string expressions (9 bytes, 3 entries).
    ;       $0022-$0025 34-37	Temporary area for various operations (4 bytes).
    ;       $0026-$0029 38-41	Auxiliary arithmetical register for division and multiplication (4 bytes).
    
    buffer0075.02   =   0073    ;   ( 2) byte   ;   Temporary area for saving original pointer to current BASIC 
                                                ;   instruction during GET, INPUT and READ.
    buffer0104.01   =   0104    ;   ( 1) byte   ;   Temporary area for various operations.
    buffer0146.01   =   0146    ;   ( 1) byte   ;   Unknown. (Timing constant during datasette input.)

    buffer0150.01   =   0150    ;   ( 1) byte   ;   Unknown. (End of tape indicator during datasette input/output.)
    buffer0151.01   =   0151    ;   ( 1) byte   ;   Temporary area for saving original value of Y register during input from RS232.
  
    buffer0155.01   =   0155    ;   ( 1) byte   ;   Unknown. (Parity bit during datasette input/output.)
    buffer0156.01   =   0156    ;   ( 1) byte   ;   Unknown. (Byte ready indicator during datasette input/output.)

    buffer0176.02   =   0176    ;   ( 2) byte   ;   Unknown.
    buffer0191.01   =   0191    ;   ( 1) byte   ;   Unknown.

    ;
    
    buffer0645.01   =   0645    ;   ( 1) byte   ;   Unused  (Serial bus timeout.)
    buffer0679.89   =   0679    ;   (89) byte   ;   Unused  (89 bytes).              (64+15)
    buffer0787.01   =   0787    ;   ( 1) byte   ;   Unused
    buffer0814.02   =   0814    ;   ( 2) byte   ;   Unused  Default: $FE66.              (2)
    buffer0820.08   =   0820    ;   (48) byte   ;   Unused (8 bytes).                    (8)
    buffer0828.192  =   0828    ;  (192) byte   ;   Datasette buffer (192 bytes).   (128+64)
    buffer1020.04   =   1020    ;   ( 4) byte   ;   Unused (4 bytes).                    (4)
    buffer2024.15   =   2024    ;   (15) byte   ;   Unused (15 bytes).  **              (15) 
    ;       **
    ;       screen  :    1024   -   2023
    ;                    $0400   -  $07E7
    ;       buffer  :    2024   -   2039    (15)   buffer
    ;               :    2040   -   2047    (8)    sprite
    ;       program :    2049   -   ->
    
.pend

;**********
;           sys
;**********

sys .proc

    CHROUT          = $FFD2     ;   a
    CHRIN           = $ffcf     ;   
    STROUT          = $ab1e     ;       
    OUT_U16         = $BDCD     ;   ax
    SCREEN_XY       = $fff0     ;   C=1 read cursor pos(xy)   C=0 set cursor pos(xy) 
    SCREEN_WH       = $ffed     ;   
    SCREEN_CLEAR    = $e544     ;
    SCREEN_HOME     = $e566     ;
    IOINIT          = $ff84     ;
    RESTOR          = $ff8a     ;
    CINT            = $ff81     ;

.pend

;**********
;           color
;**********

color .proc

    black          =       0               ;       0000
    white          =       1               ;       0001
    red            =       2               ;       0010
    cyan           =       3               ;       0011
    violet         =       4               ;       0100
    green          =       5               ;       0101
    blue           =       6               ;       0110
    yellow         =       7               ;       0111

    orange         =       8               ;       1000
    brown          =       9               ;       1001
    light_red      =       10              ;       1010
    dark_grey      =       11              ;       1011
    grey           =       12              ;       1100
    light_green    =       13              ;       1101
    light_blue     =       14              ;       1110
    light_grey     =       15              ;       1111

    default_border      =   254
    default_background  =   246
    default_foreground  =   254
    
.pend

;******
;       char
;******

char .proc

        ;   $CHROUT

        home            =   19
        nl              =   13
        clear_screen    =   147    ;   restore original color
        
        ; $0400
        
        space           =   ' '
        dollar          =   '$'
        a               =   1
        b               =   2

.pend

;******
;       c64
;******

c64 .proc

        ;---------------------------------------------------------------  c64
        
        EXTCOL          = $d020     ;   53280
        
        BGCOL0          = $d021     ;
        BGCOL1          = $d022     ;
        BGCOL2          = $d023     ;
        BGCOL4          = $d024     ;
        
        COLOR           = $0286     ;

        ;---------------------------------------------------------------  address
        
        .weak
            screen_addr     =   $0400
        .endweak
        
            color_addr      =   $d800
        
        .weak
            ;bitmap_addr     =   $e000
            bitmap_addr     =   $2000
            bitmap_size     =   320*200/8
        .endweak
        
        ;---------------------------------------------------------------  constant
        
        screen_max_width            =   $28    ;   40
        screen_max_height           =   $19    ;   25

        ;---------------------------------------------------------------  register
        
        screen_control_register_1   =   53265
        screen_control_register_2   =   53270

        ;---------------------------------------------------------------  
        
        ;******
        ;       system
        ;******

        timerA  .proc
            stop .proc
                lda	#$fe        ;   1111:11[10]
                and	$dc0e       ;
                sta	$dc0e
                rts
            .pend
            start .proc
                lda	#$01        ;   0000:0001
                ora	$dc0e
                sta	$dc0e
                rts
            .pend
        .pend

        ;   address 0001    bits 76543[210]
        
        mem .proc
            default .proc
                lda #%00000111
                and $01
                sta $01
                rts
            .pend
            to_rom_AE .proc
                jsr default
                lda	#$02        ;   0000:00[10] %x10:  RAM visible at $A000-$BFFF; 
                ora	$01         ;                      KERNAL ROM visible at $E000-$FFFF.
                sta $01
                rts
            .pend
            to_ram_AE .proc
                jsr default
                lda	#$fd        ;   1111:11[01]	%x01: RAM visible at $A000-$BFFF,
                and	$01         ;                                and $E000-$FFFF.
                sta $01
                rts
            .pend
        .pend

       
        set_bank    .proc
                ora $dd00
                sta $dd00
                rts
        .pend
        
        ;******
        ;       sub
        ;******

        ; ........................................... set mode
        
        set_text_mode_on 
        set_text_mode_standard_on
        set_bitmap_mode_off
            lda 53265
            and #%11011111  ;   bit5
            sta 53265
            
            jsr txt.set_border_color
            jsr txt.set_background_color
            
            rts

        ; ........................................... set bitmap mode ON 
        ; ........................................... set text mode OFF 
        
        set_text_mode_off 
        set_text_mode_standard_off
        set_bitmap_mode_on
            lda 53265
            ora #%00100000
            sta 53265

            ;jsr txt.set_border_color
            ;jsr txt.set_background_color
            
            rts 

        ; ........................................... set text extended background mode ON 
        
        set_text_mode_extended_on
            lda 53265
            ora #%01000000  ; bit 6
            sta 53265

            lda screen.border_color
            sta $d020
            
            lda screen.background_color_0
            sta $d021
            lda screen.background_color_1
            sta $d022
            lda screen.background_color_2
            sta $d023
            lda screen.background_color_3
            sta $d024

            lda screen.foreground_color
            jsr txt.clear_screen_colors
            
            rts

        ; ........................................... set text extended background mode OFF 
        
        set_text_mode_extended_off
            lda 53265
            and #%10111111
            sta 53265

            rts

        ; ........................................... set bitmap mode MC ON 
        
        set_text_mode_multicolor_on
        set_bitmap_mode_multicolor_on
            lda 53270
            ora #%00010000  ;ora #16
            sta 53270

            ;lda screen.border_color
            ;sta $d020
            lda screen.background_color_0
            sta $d021
            lda screen.background_color_1
            sta $d022
            lda screen.background_color_2
            sta $d023
            lda screen.background_color_3
            sta $d024
            
            rts 

        ; ........................................... set bitmap mode MC OFF 
        
        set_text_mode_multicolor_off        
        set_bitmap_mode_multicolor_off
            lda 53270
            and #%11101111  ;and #239
            sta 53270
            
            rts 

        ; ........................................... set bitmap mode 320x200 on / off 
        
        set_bitmap_mode_320x200_on  .proc
            jsr set_bitmap_mode_on
            jsr set_bitmap_mode_multicolor_off
            jsr set_text_mode_extended_off
            rts
        .pend

        set_bitmap_mode_320x200_off  .proc
            jsr set_bitmap_mode_off
            jsr set_bitmap_mode_multicolor_off
            rts
        .pend

        ; ........................................... set bitmap mode 160x200 on / off 
        
        set_bitmap_mode_160x200_on  .proc
            jsr set_bitmap_mode_on
            jsr set_bitmap_mode_multicolor_on
            jsr set_text_mode_extended_off
            rts
        .pend
        
        set_bitmap_mode_160x200_off  .proc
            jsr set_bitmap_mode_off
            jsr set_bitmap_mode_multicolor_off
            rts
        .pend

        ; ........................................... set screen bitmap offset 

        set_screen_0c00_bitmap_2000_addr    .proc
                            ;	7654:3210	(53272)
            lda #%00110011	;	0011:1000
            sta	$d018	    ;	%100u,  4: $2000-$3FFF, 8192-16383.	pointer to bitmap memory
                            ;	%0011,  3: $0C00-$0FFF, 3072-4095.	Pointer to screen memory
            rts
        .pend
                            
        set_screen_0400_bitmap_2000_addr    .proc
                            ;	7654:3210	(53272)
            ;lda #%00010101  ;	0001:1000
            lda #%00011000  ;	0001:1000
            sta	$d018	    ;	%100u,  4: $2000-$3FFF, 8192-16383.	pointer to bitmap memory
                            ;	%0001,  3: $0400-$0FFF, 1024-2048.	Pointer to screen memory
            rts
        .pend
                            
        ; ........................................... check mode 
        
        check_text_mode_standard    .proc

            lda c64.screen_control_register_1
            test_bit_5
            bne   check_text_mode_standard_1
            clc
            rts
            check_text_mode_standard_1
            sec
            rts
            
        .pend
        
        check_text_mode_extended    .proc

            lda c64.screen_control_register_1
            test_bit_6
            bne   check_text_mode_extended_1 
            clc
            rts
        check_text_mode_extended_1
            sec
            rts
            
        .pend
        
        check_bitmap_mode         .proc

            lda c64.screen_control_register_1
            test_bit_5
            bne   check_bitmap_mode_1 
            clc
            rts
        check_bitmap_mode_1
            sec
            rts
            
        .pend

        check_multi_color         .proc

            lda c64.screen_control_register_2
            test_bit_4
            bne   + 
            clc
            rts
        +
            sec
            rts
            
        .pend

        check_bitmap_mode_320x200   .proc
        
            jsr check_bitmap_mode
            if_false    no
            jsr check_multi_color
            if_true     no
        si
            sec
            rts
        no 
            clc
            rts
            
        .pend

        check_bitmap_mode_160x200   .proc
        
            jsr check_bitmap_mode
            if_false    no
            jsr check_multi_color
            if_false    no
        si
            sec
            rts
        no 
            clc
            rts
            
        .pend

        ; ...........................................c64.start
        ;
        ;   input   :   
        ;               zpWord0     from
        ;               zpWord1     to
        ;               xy          value
        
        start   .proc

            cld
            
            tsx
            txa
            sta stack.old
            
            ldx  #255                   ; init stack ptr
            stx  stack.pointer
            
            clv
            clc
    
            jsr  c64.init_system
            jsr  c64.init_system_phase2 ;   no phase 2 in C64
            
            ;--------------
            
            jsr  main.start
            
            ;--------------

            lda  #31
            sta  $01
            
            jmp  c64.cleanup_at_exit
            
            lda stack.old
            tax
            txs
            
            rts
            
        .pend

        init_system    .proc

            sei
            cld
            
            lda  #%00101111
            sta  $00
            lda  #%00100111
            sta  $01
            
            jsr  sys.IOINIT
            jsr  sys.RESTOR
            jsr  sys.CINT
            
            lda  #color.black
            sta  c64.EXTCOL
            sta  screen.border_color
            
            lda  #color.green
            sta  c64.COLOR
            sta  screen.foreground_color
            
            lda  #color.black
            sta  c64.BGCOL0
            sta  screen.background_color
            
            jsr  disable_runstop_and_charsetswitch
            
            clc
            clv
            cli
            
            rts
                
    .pend

    init_system_phase2    .proc

        rts     ; no phase 2 steps on the C64
        
    .pend

    disable_runstop_and_charsetswitch    .proc

        lda  #$80
        sta  657    ; disable charset switching
        lda  #239
        sta  808    ; disable run/stop key
        
        rts
        
    .pend

    cleanup_at_exit    .proc
 
            jmp  c64.enable_runstop_and_charsetswitch
    .pend
 
    enable_runstop_and_charsetswitch    .proc

        lda  #0
        sta  657    ; enable charset switching
        
        lda  #237
        sta  808    ; enable run/stop key
        
        rts
        
    .pend

        ; ........................................... peek_word
        ;
        ;   input   :   ay  ->  y   =   peek ( a0:a1,y+0 ) , y
        ;                       a   =   peek ( a0:a1,y+1 ) , a
        ;  (a,y) := (word)*(zpWord0)
        
        peekw  .proc
            ; -- read the word value on the address in AY
            sta  zpWord0
            sty  zpWord0+1
            ldy  #0
            lda  (zpWord0),y
            pha
            iny
            lda  (zpWord0),y
            tay
            pla
            rts
        .pend

        ; ........................................... poke_word
        ;
        ;   input   :   ay  ->  zpWord+1    =   poke ( a0:a1,y+0 ) , y
        ;                       zpWord+0    =   poke ( a0:a1,y+1 ) , a
        ;   *(zpWord0) := (a:y)

        pokew   .proc
            ; -- store the word value in AY in the address in zpWord0
            sty  zpx
            ldy  #0
            sta  (zpWord0),y
            iny
            lda  zpx
            sta  (zpWord0),y
            rts
        .pend
        

.pend

;******
;       macro
;******

;--------------------------------------------------------------- test flag

test_bit_0   .macro
    and #%00000001
.endm
test_bit_1   .macro
    and #%00000010
.endm
test_bit_2   .macro
    and #%00000100
.endm
test_bit_3   .macro
    and #%00001000
.endm
test_bit_4   .macro
    and #%00010000
.endm
test_bit_5   .macro
    and #%00100000
.endm
test_bit_6   .macro
    and #%01000000
.endm
test_bit_7   .macro
    and #%10000000
.endm

 ;   non settato     =   0
if_bit_0 .macro
        beq \1
.endm

 ;  settato         =   1
if_bit_1 .macro
        bne \1
.endm
   

; ---------------------------------------------------------------   ay
;
;   ay      lohi
;
;   a   <   lo
;   y   >   hi
;

load_imm_ay	.macro
    lda <\1
    ldy >\1
.endm

load_var_ay	.macro
    lda \1 
    ldy \1+1
.endm

load_address_ay	.macro
    lda #<\1
    ldy #>\1
.endm

switch_ay .macro
    sta zpa
    sty zpy
    lda zpy
    ldy zpa
.endm

; ---------------------------------------------------------------   xy

load_imm_xy .macro
    ldx <\1
    ldy >\1
.endm

load_var_xy .macro
    ldx \1 
    ldy \1+1
.endm

; ---------------------------------------------------------------

load_address_zpWord0	.macro
    lda #<\1
    sta zpWord0
    ldy #>\1
    sty zpWord0+1
.endm

load_imm_zpWord0    .macro
    lda <\1
    sta zpWord0
    ldy >\1
    sty zpWord0+1
.endm

store_imm_zpWord0	.macro
    lda <\1
    sta zpWord0
    ldy >\1
    sty zpWord0+1
.endm

load_address_zpWord1	.macro
	lda #<\1
    sta zpWord1
	ldy #>\1
    sty zpWord1+1
.endm

store_imm_zpWord1	.macro
    lda <\1
    sta zpWord1
    ldy >\1
    sty zpWord1+1
.endm

; ---------------------------------------------------------------

load_zpByte0	.macro

	lda \1
	sta zpByte0

.endm

load_zpWord0	.macro

	lda \1
	sta zpWord0
	lda \1+1
	sta zpWord0+1
	
.endm

; ---------------------------------------------------------------

load_zpByte1	.macro

	lda \1
	sta zpByte1

.endm

load_zpWord1	.macro

	lda \1
	sta zpWord1
	lda \1+1
	sta zpWord1+1
	
.endm

load_imm_zpWord1	.macro

	lda <\1
    sta zpWord1
	ldy >\1
    sty zpWord1+1
    
.endm

; --------------------------------------------------------------- if then

then	.macro
	bcs \1
.endm

else	.macro
	bcc \1
.endm

; --------------------------------------------------------------- logical true false

if_true  .macro
    bcs \1        ;   non settato     =   0
.endm

if_false .macro
    bcc \1         ;  settato         =   1
.endm

;--------------------------------------------------------------- string compare

if_string_lt .macro
    cmp #$ff
    beq \1
.endm

if_string_eq .macro
    cmp #$00
    beq \1
.endm

if_string_gt .macro
    cmp #$01
    beq \1
.endm

;--------------------------------------------------------------- macro graph

graph_imm_x  .macro
    lda <\1
    sta zpWord0
    lda >\1
    sta zpWord0+1
.endm

graph_var_x  .macro
    lda \1
    sta zpWord0
    lda \1+1
    sta zpWord0+1
.endm

graph_imm_y  .macro
    lda \1
    sta zpy
.endm

graph_var_y  .macro
    lda \1
    sta zpy
.endm


;--------------------------------------------------------------- macro

u8_type  .macro
    \1    .byte    \2
.endm

s8_type   .macro
    \1    .char    \2
.endm

u16_type   .macro
    \1    .word    \2
.endm

s16_type   .macro
    \1    .sint    \2
.endm

cstring_type   .macro
    \1    .null    \2
.endm

pstring_type   .macro
    \1    .null    \2 , \3
.endm

;******
;       mem
;******


mem .proc

    ; ........................................... mem.copy
    ;
    ;   input   :
    ;               source address  ->  zpWord0
    ;               dest   address  ->  zpWord1
    ;               ay              ->  size
    ;   output  :
    ;               //
    
   copy    .proc
     
                cpy  #0
                bne  _longcopy

                ; copy <= 255 bytes
                tay
                bne  _copyshort
                rts     ; nothing to copy

    _copyshort
                ; decrease source and target pointers so we can simply index by Y
                lda  zpWord0
                bne  +
                dec  zpWord0+1
    +           dec  zpWord0
                lda  zpWord1
                bne  +
                dec  zpWord1+1
    +           dec  zpWord1

    -           lda  (zpWord0),y
                sta  (zpWord1),y
                dey
                bne  -
                rts

    _longcopy
                sta  zpy        ; lsb(count) = remainder in last page
                tya
                tax                         ; x = num pages (1+)
                ldy  #0
    -           lda  (zpWord0),y
                sta  (zpWord1),y
                iny
                bne  -
                inc  zpWord0+1
                inc  zpWord1+1
                dex
                bne  -
                ldy  zpy
                bne  _copyshort
                rts
    .pend

    ; ........................................... mem.set
    ;
    ;   input   :   
    ;               zpWord0     begin
    ;               xy          length
    ;               a           value

    set_byte          .proc
    
            ; -- fill memory from (zpWord0), length XY, with value in A.
            
            stx  zpy
            sty  zpx
            ldy  #0
            ldx  zpx
            beq  _lastpage
    _fullpage    
            sta  (zpWord0),y
            iny
            bne  _fullpage
            inc  zpWord0+1          ; next page
            dex
            bne  _fullpage
    _lastpage    
            ldy  zpy
            beq  +
    -             
            dey
            sta  (zpWord0),y
            bne  -
    +               
            rts

    .pend
    
    ; ........................................... mem.set_word
    ;
    ;   input   :   
    ;               zpWord0     begin
    ;               zpWord1     length
    ;               ay          value

    set_word        .proc

        ; --    fill memory from (zpWord0) 
        ;       number of words in zpWord1, 
        ;       with word value in AY.
        
            sta  _mod1+1                    ; self-modify
            sty  _mod1b+1                   ; self-modify
            sta  _mod2+1                    ; self-modify
            sty  _mod2b+1                   ; self-modify
            ldx  zpWord0
            stx  zpWord2
            ldx  zpWord0+1
            inx
            stx  zpx                ; second page

            ldy  #0
            ldx  zpWord1+1
            beq  _lastpage
    _fullpage
    _mod1           
            lda  #0                 ; self-modified
            sta  (zpWord0),y        ; first page
            sta  (zpWord2),y        ; second page
            iny
    _mod1b        lda  #0                         ; self-modified
            sta  (zpWord0),y        ; first page
            sta  (zpWord2),y        ; second page
            iny
            bne  _fullpage
            inc  zpWord0+1          ; next page pair
            inc  zpWord0+1          ; next page pair
            inc  zpWord2+1          ; next page pair
            inc  zpWord2+1          ; next page pair
            dex
            bne  _fullpage
    _lastpage    
            ldx  zpWord1
            beq  _done

            ldy  #0
    -
    _mod2           
            lda  #0                         ; self-modified
            sta  (zpWord0), y
            inc  zpWord0
            bne  _mod2b
            inc  zpWord0+1
    _mod2b          
            lda  #0                         ; self-modified
            sta  (zpWord0), y
            inc  zpWord0
            bne  +
            inc  zpWord0+1
    +               
            dex
            bne  -
    _done        
            rts
            
    .pend

    ; ........................................... mem.copy_npage_from_to
    ;
    ;   input   :   
    ;               zpWord0     from
    ;               zpWord1     to
    ;               xy          length

    copy_npage_from_to    .proc
    
        ; -- copy memory from (zpWord0) to (zpWord1) of length X/Y (16-bit, X=lo, Y=hi)

            source  = zpWord0
            dest    = zpWord1
            length  = zpWord2   ; (and SCRATCH_ZPREG)

            stx  length
            sty  length+1

            ldx  length             ; move low byte of length into X
            bne  +                  ; jump to start if X > 0
            dec  length             ; subtract 1 from length
    +        
            ldy  #0                 ; set Y to 0
    -        
            lda  (source),y         ; set A to whatever (source) points to offset by Y
            sta  (dest),y           ; move A to location pointed to by (dest) offset by Y
            iny                     ; increment Y
            bne  +                  ; if Y<>0 then (rolled over) then still moving bytes
            inc  source+1           ; increment hi byte of source
            inc  dest+1             ; increment hi byte of dest
    +        
            dex                     ; decrement X (lo byte counter)
            bne  -                  ; if X<>0 then move another byte
            dec  length             ; we've moved 255 bytes, dec length
            bpl  -                  ; if length is still positive go back and move more
            rts                     ; done
            
    .pend


.pend


;;;
;;
;