

; ----------------------------------------------------------------------- basic program with sys call

* = $0801
	.word  (+), 2022
	;.null  $9e, format(' %d ', prog8_entrypoint), $3a, $8f, ' prog8'
	.null  $9e, format(' %d ', main.program), $3a, $8f, ' prog8'
+	.word  0

; ----------------------------------------------------------------------- include

.include "..\lib\libC64.asm"

; ----------------------------------------------------------------------- prog8_entrypoint

prog8_entrypoint	; assembly code starts here
	jsr  c64.init_system
	jsr  c64.init_system_phase2
	; zeropage is clobbered so we need to reset the machine at exit
	lda  #>sys.reset_system
	pha
	lda  #<sys.reset_system
	pha
	jsr  main.start
	lda  #31
	sta  $01
	jmp  c64.cleanup_at_exit
    
    rts
    
; ----------------------------------------------------------------------- main

main	.proc

; ----------------------------------------------------------------------- start

    start	.proc
    
        ; program startup initialization
        cld
        jsr  diskio.prog8_init_vars
        jsr  graphics.prog8_init_vars
    +       
        tsx
        stx  prog8_lib.orig_stackpointer    ; required for sys.exit()
        ldx  #255                           ; init estack ptr
        clv
        clc

        jsr program

        rts
        
        .pend
        
; ----------------------------------------------------------------------- program begin

        stringa .text   "salve gente",0

        program	.proc

            lda #'.'
            jsr txt.clear_screenchars

            lda #c64.cRed
            jsr txt.clear_screencolors
            
            jsr txt.spc  
              
            lda #123
            jsr txt.print_ub
            
            jsr txt.nl

            rts
            
        .pend

; ----------------------------------------------------------------------- program end


.pend



;;;
;;
;



