
num16_1lo  = $ff
num16_1hi  = $fe

num16_2lo  = $fd
num16_2hi  = $fc

res16_lo   = $fb
res16_hi   = $fa


; adds num16_bers 1 and 2, writes res16_ult to separate location

add16     
        clc                                ; clear carry
        lda num16_1lo
        adc num16_2lo
        sta res16_lo                       ; store sum of LSBs
        lda num16_1hi
        adc num16_2hi                      ; add the MSBs using carry from
        sta res16_hi                       ; the previous calculation
        rts

; subtracts num16_ber 2 from num16_ber 1 and writes res16_ult out

sub16     
        sec                                ; set carry for borrow purpose
        lda num16_1lo
        sbc num16_2lo                      ; perform subtraction on the LSBs
        sta res16_lo
        lda num16_1hi                      ; do the same for the MSBs, with carry
        sbc num16_2hi                      ; set according to the previous res16_ult
        sta res16_hi
        rts
;