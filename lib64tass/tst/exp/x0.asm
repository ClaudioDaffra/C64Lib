.cpu  '6502'
.enc  'none'


; ---- basic program with sys call ----
* = $0801
	.word  (+), 2022
	.null  $9e, format(' %d ', prog8_entrypoint), $3a, $8f, ' prog8'
+	.word  0
prog8_entrypoint	; assembly code starts here
	jmp main.start

;--------------------------------------------------------------- lib

.include "libC64.asm"
.include "libMath.asm"
.include "libSTDIO.asm"

;--------------------------------------------------------------- main
stringa .null "claudio" 



;----------------------------------------------------- type

;---------------------------
signed8         .char(-30)
unsigned16      .word(8192)
signed16        .sint(-32455)

n1 = $fa
n2 = $fb

main	.proc

    ; Signed comparison
    ;
    ; Returns with:
    ;   N=0 (BPL branches) if n1 >= n2 (signed)
    ;   N=1 (BMI branches) if n1 < n2 (signed)
    ;
    ; The unsigned comparison result is returned in the C flag (for free)
    ;
    scmp    .proc
            sec
            lda n1     ; Compare n1 and n2
            sbc n2
            bvc scmp1  ; Branch if V = 0
            eor #$80   ; Invert Accumulator bit 7 (which also inverts the N flag)
    scmp1   
            rts
    .pend

    start	.proc

            lda #1
            sta n1
            
            lda #0
            sta n2
            
            jsr scmp
    
            beq     equal
            bmi     lessThan
            bpl     greaterEqual
            
            rts
            
    equal
            lda #'='
            sta 1024
            rts
    lessThan
            lda #'<'
            sta 1024
            rts            
    greater
            lda #'>'
            sta 1024
            rts 
    greaterEqual
            lda #'>'
            sta 1024
            lda #'='
            sta 1025
            rts 
    .pend

.pend



;   -10 111
;   -10 112





