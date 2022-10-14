
;*********
; HEADER
;*********

.cpu  '6502'
.enc  'none'

; [start address]
* = $0801
    ;           [line]
    .word  (+), 2022
    ;2022 [sys] [2069] :rem prg                     [rem]     [desc]
	.null  $9e, format(' %d ', program_entry_point), $3a, $8f, ' prg'
+   .word  0

;*********
; entry
;*********

program_entry_point

jmp program

;*********
; lib
;*********

.include "../../lib/libC64.asm"

;*********
; program
;*********

program .proc

       jsr c64.start    ;   call main.start
       
       rts
       
.pend


;*********
; GLOBAL
;*********

    cmd .null   " 987 "
    end .null   " end "  

;*********
; MAIN
;*********

main    .proc

    start   .proc

        jsr basic.txtptr.push   ;   basic_txtptr_push

        ;   begin
        
        .load_address_ay cmd
        jsr basic.txtptr.set

        jsr basic.get_char      ;   jsr GETCHAR   ;   get char

        ;jsr GETBYTE 
        ;txa
        ;jsr std.print_u8_dec
        sta 1024

        ;   end
        
        jsr basic.txtptr.pop    ;   basic_txtptr_pop
        
        rts
    
    .pend

.pend

;;;
;;
;
