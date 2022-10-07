

.cpu  '6502'
.enc  'none'

; ---- basic program with sys call ----

; [start address]

* = $0801
    ;           [line]
	.word  (+), 2022
    ;      [sys]                                     [rem]     [desc]
	.null  $9e, format(' %d ', program_entry_point), $3a, $8f, ' prg'
+	.word  0

program_entry_point	; assembly code starts here

	jmp main.start

;--------------------------------------------------------------- lib

.include "../../lib/libC64.asm"

;--------------------------------------------------------------- main

main	.proc

    start	.proc

        ; bank default
        
        lda #c64.bank0
        jsr c64.set_bank
        
        ;
        
        lda #%10101111
        sec
        jsr std.print_u8_bin

        lda #char.nl
        jsr c64.CHROUT
        
        sec
        lda #%10101111
        and #%11111100
        jsr std.print_u8_bin

        lda #char.nl
        jsr c64.CHROUT
        
        ; rom default
 
        jsr c64.mem.default
        lda  #12
        sta  $e000
        lda  $e000
        jsr txt.print_u8_dec

        lda #char.nl
        jsr c64.CHROUT

        ; rom disable  $a000 - $e000

        jsr c64.timerA.stop
        jsr c64.mem.to_ram_AE

        lda  #21
        sta  $e000
        lda  $e000
        sta  zpa

        ; rom enable  $a000 - $e000

        jsr c64.timerA.start
        jsr c64.mem.to_rom_AE

        lda zpa
        jsr txt.print_u8_dec

        rts
        
    .pend

.pend

;;;
;;
;

