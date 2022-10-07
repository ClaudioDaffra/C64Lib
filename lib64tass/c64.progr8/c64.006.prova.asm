

.cpu  '6502'
.enc  'none'

; ---- basic program with sys call ----

; [start address]

* = $0801
    ;           [line]
    .word  (+), 2022
    ;      [sys]                                     [rem]     [desc]
    .null  $9e, format(' %d ', program_entry_point), $3a, $8f, ' prg'
+   .word  0

;--------------------------------------------------------------- program_entry_point

program_entry_point

    jmp program

;--------------------------------------------------------------- lib

.include "../../lib/libC64.asm"

;--------------------------------------------------------------- sub

;--------------------------------------------------------------- program

program .proc

       jsr c64.start    ;   -> call main.start
       
       rts
       
.pend

;--------------------------------------------------------------- main

main	.proc

    start	.proc

            ;   program
 
            ; .............................................. setup memory
            
            ; IMP !
            ;
            ;   ... TO USE bitmap txt,  other location
            ;   ... TO USE routine txt,  for screen offset 0
            ;
            ;   64tass -D bitmap_addr = $E000 -D screen_addr = 0
            ;
            
            ;jsr c64.setPortA_RW

            ;   bank3   00      C000    49152
            ;   bank2   01      8000    32768
            ;   bank1   10      4000    16384
            ;   bank0   11      0000        0
            
;   $DD00
            lda #c64.bank3
            jsr c64.set_bank
;   $D018            
            lda #c64.bitmap1
            jsr c64.setBitmapOffset

            lda #c64.screen0
            jsr c64.setScreenOffset

;     648
            ;        $c000            $0000
            lda # (( c64.bank_addr3 + c64.screen_addr0 ) / 256 )
            sta c64.SCRPTR

                   ;-------------------------
                    charset = $d000
                    screen  = $F000
                    ;calc d018/bank values
                    ns = >screen<<2
                    nc = (>charset&$3f)>>2
                    v18 = (ns|nc)&$ff
                    bank = 3-(>screen>>6)
                    ;-------------------------
                    
            ; copy charset from chargen to the RAM at the same address
            ; else load your favourite charset here
            sei
            ldx #$08
            lda #$33 ; see the chargen at $d000
            sta $01
            lda #>charset
            sta $fc
            ldy #$00
            sty $fb
        lp1
            lda ($fb),y
            inc $01
            sta ($fb),y
            dec $01
            iny
            bne lp1
            inc $fc
            dex
            bne lp1
            lda #$37 ; ROM active
            sta $01
            cli
                    
            jsr sys.CLEARSCR
            
            lda #147
            jsr sys.CHROUT
            
            ;   scrive A
            
            lda #1
            sta 49152+0
 
        rts
 

    .pend

.pend

;;;
;;
;

