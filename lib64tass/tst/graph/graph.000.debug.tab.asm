

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

    i       .byte   0
    maxi    .byte   0
    
    debug_table .proc

        sta zpWord0             ;   <
        sty zpWord0+1           ;   >
        jsr txt.print_u16_hex

        lda #char.nl
        jsr c64.CHROUT
        
        lda #255    ;   -1
        sta i
        loop
            ldy i
            iny     ;   -1  ->  0
            sty i
            
            lda #' '
            jsr c64.CHROUT
            
            ldy i
            lda (zpWord0),y
            jsr std.print_u8_hex
            
            ldy i
            cpy maxi
            
        bne loop
        rts
        
    .pend
    
    
    start	.proc

        ; debug tbl_vbase
        
        lda #char.nl
        jsr c64.CHROUT

        lda #25
        sta maxi
        
        .load_address_ay graph.tbl_vbaseLo
        jsr debug_table

        lda #char.nl
        jsr c64.CHROUT

        .load_address_ay graph.tbl_vbaseHi
        jsr debug_table

        ; debug tbl_8

        lda #40
        sta maxi
        
        lda #char.nl
        jsr c64.CHROUT

        .load_address_ay graph.tbl_8Lo
        jsr debug_table

        lda #char.nl
        jsr c64.CHROUT

        .load_address_ay graph.tbl_8Hi
        jsr debug_table
        
        
        rts
        
    .pend

.pend

;;;
;;
;
