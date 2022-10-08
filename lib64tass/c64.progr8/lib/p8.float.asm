
; ######################################################################### floats.p8

; Prog8 definitions for floating point handling on the Commodore-64

%option enable_floats
%import floats_functions

floats {
	; ---- this block contains C-64 floating point related functions ----

        const float  PI     = 3.141592653589793
        const float  TWOPI  = 6.283185307179586


; ---- C64 basic and kernal ROM float constants and functions ----

		; note: the fac1 and fac2 are working registers and take 6 bytes each,
		; floats in memory  (and rom) are stored in 5-byte MFLPT packed format.


; note: fac1/2 might get clobbered even if not mentioned in the function's name.
; note: for subtraction and division, the left operand is in fac2, the right operand in fac1.
romsub $bba2 = MOVFM(uword mflpt @ AY) clobbers(A,Y)        
; load mflpt value from memory  in A/Y into fac1

romsub $bba6 = FREADMEM() clobbers(A,Y)                     
; load mflpt value from memory  in $22/$23 into fac1

romsub $ba8c = CONUPK(uword mflpt @ AY) clobbers(A,Y)       
; load mflpt value from memory  in A/Y into fac2
romsub $ba90 = FAREADMEM() clobbers(A,Y)                    
; load mflpt value from memory  in $22/$23 into fac2
romsub $bbfc = MOVFA() clobbers(A,X)                        
; copy fac2 to fac1
romsub $bc0c = MOVAF() clobbers(A,X)                        
; copy fac1 to fac2  (rounded)
romsub $bc0f = MOVEF() clobbers(A,X)                        
; copy fac1 to fac2
romsub $bbd4 = MOVMF(uword mflpt @ XY) clobbers(A,Y)        
; store fac1 to memory  X/Y as 5-byte mflpt
; fac1-> signed word in Y/A (might throw ILLEGAL QUANTITY)
; (tip: use floats.FTOSWRDAY to get A/Y output; lo/hi switched to normal little endian order)
romsub $b1aa = FTOSWORDYA() clobbers(X) -> ubyte @ Y, ubyte @ A       
; note: calls AYINT.
; fac1 -> unsigned word in Y/A (might throw ILLEGAL QUANTITY) (result also in $14/15)
; (tip: use floats.GETADRAY to get A/Y output; lo/hi switched to normal little endian order)
romsub $b7f7 = GETADR() clobbers(X) -> ubyte @ Y, ubyte @ A
romsub $bc9b = QINT() clobbers(A,X,Y)           
; fac1 -> 4-byte signed integer in 98-101 ($62-$65), with the MSB FIRST.
romsub $b1bf = AYINT() clobbers(A,X,Y)          
; fac1-> signed word in 100-101 ($64-$65) MSB FIRST. (might throw ILLEGAL QUANTITY)
; GIVAYF: signed word in Y/A (note different lsb/msb order) -> float in fac1
; (tip: use floats.GIVAYFAY to use A/Y input; lo/hi switched to normal order)
; there is also floats.GIVUAYFAY - unsigned word in A/Y (lo/hi) to fac1
; there is also floats.FREADS32  that reads from 98-101 ($62-$65) MSB FIRST
; there is also floats.FREADUS32  that reads from 98-101 ($62-$65) MSB FIRST
; there is also floats.FREADS24AXY  that reads signed int24 into fac1 from A/X/Y (lo/mid/hi bytes)
romsub $b391 = GIVAYF(ubyte lo @ Y, ubyte hi @ A) clobbers(A,X,Y)
romsub $b3a2 = FREADUY(ubyte value @ Y) clobbers(A,X,Y)     
; 8 bit unsigned Y -> float in fac1
romsub $bc3c = FREADSA(byte value @ A) clobbers(A,X,Y)      
; 8 bit signed A -> float in fac1
romsub $b7b5 = FREADSTR(ubyte length @ A) clobbers(A,X,Y)   
; str -> fac1, $22/23 must point to string, A=string length

        romsub $aabc = FPRINTLN() clobbers(A,X,Y)                   
        ; print string of fac1, on one line (= with newline) destroys fac1.  
        (consider FOUT + STROUT as well)

romsub $bddd = FOUT() clobbers(X) -> uword @ AY             
; fac1 -> string, address returned in AY ($0100)
romsub $b849 = FADDH() clobbers(A,X,Y)                      
; fac1 += 0.5, for rounding- call this before INT
romsub $bae2 = MUL10() clobbers(A,X,Y)                      
; fac1 *= 10
romsub $bafe = DIV10() clobbers(A,X,Y)                      
; fac1 /= 10 , CAUTION: result is always positive!
romsub $bc5b = FCOMP(uword mflpt @ AY) clobbers(X,Y) -> ubyte @ A   ; A = compare fac1 to mflpt in A/Y, 0=equal 1=fac1 is greater, 255=fac1 is less than
romsub $b86a = FADDT() clobbers(A,X,Y)                      
; fac1 += fac2
romsub $b867 = FADD(uword mflpt @ AY) clobbers(A,X,Y)       
; fac1 += mflpt value from A/Y
romsub $b853 = FSUBT() clobbers(A,X,Y)                      
; fac1 = fac2-fac1   mind the order of the operands
romsub $b850 = FSUB(uword mflpt @ AY) clobbers(A,X,Y)       
; fac1 = mflpt from A/Y - fac1
romsub $ba2b = FMULTT() clobbers(A,X,Y)                     
; fac1 *= fac2
romsub $ba28 = FMULT(uword mflpt @ AY) clobbers(A,X,Y)      
; fac1 *= mflpt value from A/Y
romsub $bb12 = FDIVT() clobbers(A,X,Y)                      
; fac1 = fac2/fac1  (remainder in fac2)  mind the order of the operands
romsub $bb0f = FDIV(uword mflpt @ AY) clobbers(A,X,Y)       
; fac1 = mflpt in A/Y / fac1  (remainder in fac2)
romsub $bf7b = FPWRT() clobbers(A,X,Y)                      
; fac1 = fac2 ** fac1
romsub $bf78 = FPWR(uword mflpt @ AY) clobbers(A,X,Y)       
; fac1 = fac2 ** mflpt from A/Y
romsub $bd7e = FINLOG(byte value @A) clobbers (A, X, Y)     
; fac1 += signed byte in A
romsub $aed4 = NOTOP() clobbers(A,X,Y)                      
; fac1 = NOT(fac1)
romsub $bccc = INT() clobbers(A,X,Y)                        
; INT() truncates, use FADDH first to round instead of trunc
romsub $b9ea = LOG() clobbers(A,X,Y)                        
; fac1 = LN(fac1)  (natural log)
romsub $bc39 = SGN() clobbers(A,X,Y)                        
; fac1 = SGN(fac1), result of SIGN (-1, 0 or 1)
romsub $bc2b = SIGN() -> ubyte @ A                          
; SIGN(fac1) to A, $ff, $0, $1 for negative, zero, positive
romsub $bc58 = ABS()                                        
; fac1 = ABS(fac1)
romsub $bf71 = SQR() clobbers(A,X,Y)                        
; fac1 = SQRT(fac1)
romsub $bf74 = SQRA() clobbers(A,X,Y)                       
; fac1 = SQRT(fac2)
romsub $bfed = EXP() clobbers(A,X,Y)                        
; fac1 = EXP(fac1)  (e ** fac1)
romsub $bfb4 = NEGOP() clobbers(A)                          
; switch the sign of fac1 (fac1 = -fac1)
romsub $e097 = RND() clobbers(A,X,Y)                        
; fac1 = RND(fac1) float random number generator
romsub $e264 = COS() clobbers(A,X,Y)                        
; fac1 = COS(fac1)
romsub $e26b = SIN() clobbers(A,X,Y)                        
; fac1 = SIN(fac1)
romsub $e2b4 = TAN() clobbers(A,X,Y)                        
; fac1 = TAN(fac1)
romsub $e30e = ATN() clobbers(A,X,Y)                        
; fac1 = ATN(fac1)
asmsub  FREADS32() clobbers(A,X,Y)  {
	; ---- fac1 = signed int32 from $62-$65 big endian (MSB FIRST)
	%asm {{
		lda  $62
		eor  #$ff
		asl  a
		lda  #0
		ldx  #$a0
		jmp  $bc4f		; internal BASIC routine
	}}
}
asmsub  FREADUS32  () clobbers(A,X,Y)  {
	; ---- fac1 = uint32 from $62-$65 big endian (MSB FIRST)
	%asm {{
		sec
		lda  #0
		ldx  #$a0
		jmp  $bc4f		; internal BASIC routine
	}}
}
asmsub  FREADS24AXY  (ubyte lo @ A, ubyte mid @ X, ubyte hi @ Y) clobbers(A,X,Y)  {
	; ---- fac1 = signed int24 (A/X/Y contain lo/mid/hi bytes)
	;      note: there is no FREADU24AXY (unsigned), use FREADUS32 instead.
	%asm {{
		sty  $62
		stx  $63
		sta  $64
		lda  $62
		eor  #$FF
		asl  a
		lda  #0
		sta  $65
		ldx  #$98
		jmp  $bc4f		; internal BASIC routine
	}}
}
asmsub  GIVUAYFAY  (uword value @ AY) clobbers(A,X,Y)  {
	; ---- unsigned 16 bit word in A/Y (lo/hi) to fac1
	%asm {{
		sty  $62
		sta  $63
		ldx  #$90
		sec
		jmp  $bc49		; internal BASIC routine
	}}
}
asmsub  GIVAYFAY  (uword value @ AY) clobbers(A,X,Y)  {
	; ---- signed 16 bit word in A/Y (lo/hi) to float in fac1
	%asm {{
		sta  zpa
		tya
		ldy  zpa
		jmp  GIVAYF		; this uses the inverse order, Y/A
	}}
}
asmsub  FTOSWRDAY  () clobbers(X) -> uword @ AY  {
	; ---- fac1 to signed word in A/Y
	%asm {{
		jsr  FTOSWORDYA	; note the inverse Y/A order
		sta  zpa
		tya
		ldy  zpa
		rts
	}}
}
asmsub  GETADRAY  () clobbers(X) -> uword @ AY  {
	; ---- fac1 to unsigned word in A/Y
	%asm {{
		jsr  GETADR		; this uses the inverse order, Y/A
		sta  zpy
		tya
		ldy  zpy
		rts
	}}
}
&uword AYINT_facmo = $64      ; $64/$65 contain result of AYINT
%asminclude "library:c64/floats.asm"
%asminclude "library:c64/floats_funcs.asm"
}


; ############################################################### floats_funcs.asm

; --- floating point builtin functions


func_sign_f_stack	.proc
		jsr  func_sign_f_into_A
		sta  P8ESTACK_LO,x
		dex
		rts
		.pend

func_sign_f_into_A	.proc
		jsr  MOVFM
		jmp  SIGN
		.pend

func_swap_f	.proc
		; -- swap floats pointed to by SCRATCH_ZPWORD1, SCRATCH_ZPWORD2
		ldy  #4
-               
        lda  (zpWord0),y
		pha
		lda  (zpWord1),y
		sta  (zpWord0),y
		pla
		sta  (zpWord1),y
		dey
		bpl  -
		rts
		.pend

func_reverse_f	.proc
		; --- reverse an array of floats (array in zpWord0, num elements in A)
_left_index = zpWord1
_right_index = zpWord1+1
_loop_count = zpa
		pha
		jsr  a_times_5
		sec
		sbc  #5
		sta  _right_index
		lda  #0
		sta  _left_index
		pla
		lsr  a
		sta  _loop_count
_loop		; push the left indexed float on the stack
		ldy  _left_index
		lda  (zpWord0),y
		pha
		iny
		lda  (zpWord0),y
		pha
		iny
		lda  (zpWord0),y
		pha
		iny
		lda  (zpWord0),y
		pha
		iny
		lda  (zpWord0),y
		pha
		; copy right index float to left index float
		ldy  _right_index
		lda  (zpWord0),y
		ldy  _left_index
		sta  (zpWord0),y
		inc  _left_index
		inc  _right_index
		ldy  _right_index
		lda  (zpWord0),y
		ldy  _left_index
		sta  (zpWord0),y
		inc  _left_index
		inc  _right_index
		ldy  _right_index
		lda  (zpWord0),y
		ldy  _left_index
		sta  (zpWord0),y
		inc  _left_index
		inc  _right_index
		ldy  _right_index
		lda  (zpWord0),y
		ldy  _left_index
		sta  (zpWord0),y
		inc  _left_index
		inc  _right_index
		ldy  _right_index
		lda  (zpWord0),y
		ldy  _left_index
		sta  (zpWord0),y
		; pop the float off the stack into the right index float
		ldy  _right_index
		pla
		sta  (zpWord0),y
		dey
		pla
		sta  (zpWord0),y
		dey
		pla
		sta  (zpWord0),y
		dey
		pla
		sta  (zpWord0),y
		dey
		pla
		sta  (zpWord0),y
		inc  _left_index
		lda  _right_index
		sec
		sbc  #9
		sta  _right_index
		dec  _loop_count
		bne  _loop
		rts

		.pend



a_times_5	.proc
		sta  zpy
		asl  a
		asl  a
		clc
		adc  zpy
		rts
		.pend

func_any_f_into_A	.proc
		jsr  a_times_5
		jmp  prog8_lib.func_any_b_into_A
		.pend

func_all_f_into_A	.proc
		jsr  a_times_5
		jmp  prog8_lib.func_all_b_into_A
		.pend

func_any_f_stack	.proc
		jsr  a_times_5
		jmp  prog8_lib.func_any_b_stack
		.pend

func_all_f_stack	.proc
		jsr  a_times_5
		jmp  prog8_lib.func_all_b_stack
		.pend
        
; ##################################################################### floats.asm

; --- low level floating point assembly routines for the C64

FL_ONE_const	.byte  129     			; 1.0
FL_ZERO_const	.byte  0,0,0,0,0		; 0.0
FL_LOG2_const	.byte  $80, $31, $72, $17, $f8	; log(2)


floats_store_reg	.byte  0		; temp storage


ub2float	.proc
		; -- convert ubyte in SCRATCH_ZPB1 to float at address A/Y
		;    clobbers A, Y
		stx  zpa
		sta  zpWord1
		sty  zpWord1+1
		ldy  zpy
		lda  #0
		jsr  GIVAYF
_fac_to_mem	ldx  zpWord1
		ldy  zpWord1+1
		jsr  MOVMF
		ldx  zpa
		rts
		.pend

b2float		.proc
		; -- convert byte in SCRATCH_ZPB1 to float at address A/Y
		;    clobbers A, Y
		stx  zpa
		sta  zpWord1
		sty  zpWord1+1
		lda  zpy
		jsr  FREADSA
		jmp  ub2float._fac_to_mem
		.pend

uw2float	.proc
		; -- convert uword in SCRATCH_ZPWORD1 to float at address A/Y
		stx  zpa
		sta  zpWord1
		sty  zpWord1+1
		lda  zpWord0
		ldy  zpWord0+1
		jsr  GIVUAYFAY
		jmp  ub2float._fac_to_mem
		.pend

w2float		.proc
		; -- convert word in SCRATCH_ZPWORD1 to float at address A/Y
		stx  zpa
		sta  zpWord1
		sty  zpWord1+1
		ldy  zpWord0
		lda  zpWord0+1
		jsr  GIVAYF
		jmp  ub2float._fac_to_mem
		.pend


cast_from_uw	.proc
		; -- uword in A/Y into float var at (zpWord1)
		stx  zpa
		jsr  GIVUAYFAY
		jmp  ub2float._fac_to_mem
		.pend


cast_from_w	.proc
		; -- word in A/Y into float var at (zpWord1)
		stx  zpa
		jsr  GIVAYFAY
		jmp  ub2float._fac_to_mem
		.pend


cast_from_ub	.proc
		; -- ubyte in Y into float var at (zpWord1)
		stx  zpa
		jsr  FREADUY
		jmp  ub2float._fac_to_mem
		.pend


cast_from_b	.proc
		; -- byte in A into float var at (zpWord1)
		stx  zpa
		jsr  FREADSA
		jmp  ub2float._fac_to_mem
		.pend

cast_as_uw_into_ya	.proc               ; also used for float 2 ub
		; -- cast float at A/Y to uword into Y/A
		jsr  MOVFM
		jmp  cast_FAC1_as_uw_into_ya
		.pend

cast_as_w_into_ay	.proc               ; also used for float 2 b
		; -- cast float at A/Y to word into A/Y
		jsr  MOVFM
		jmp  cast_FAC1_as_w_into_ay
		.pend

cast_FAC1_as_uw_into_ya	.proc               ; also used for float 2 ub
		; -- cast fac1 to uword into Y/A
		stx  zpa
		jsr  GETADR     ; into Y/A
		ldx  zpa
		rts
		.pend

cast_FAC1_as_w_into_ay	.proc               ; also used for float 2 b
		; -- cast fac1 to word into A/Y
		stx  zpa
		jsr  AYINT
		ldy  floats.AYINT_facmo
		lda  floats.AYINT_facmo+1
		ldx  zpa
		rts
		.pend


stack_b2float	.proc
		; -- b2float operating on the stack
		inx
		lda  P8ESTACK_LO,x
		stx  zpa
		jsr  FREADSA
		jmp  push_fac1._internal
		.pend

stack_w2float	.proc
		; -- w2float operating on the stack
		inx
		ldy  P8ESTACK_LO,x
		lda  P8ESTACK_HI,x
		stx  zpa
		jsr  GIVAYF
		jmp  push_fac1._internal
		.pend

stack_ub2float	.proc
		; -- ub2float operating on the stack
		inx
		lda  P8ESTACK_LO,x
		stx  zpa
		tay
		lda  #0
		jsr  GIVAYF
		jmp  push_fac1._internal
		.pend

stack_uw2float	.proc
		; -- uw2float operating on the stack
		inx
		lda  P8ESTACK_LO,x
		ldy  P8ESTACK_HI,x
		stx  zpa
		jsr  GIVUAYFAY
		jmp  push_fac1._internal
		.pend

stack_float2w	.proc               ; also used for float2b
		jsr  pop_float_fac1
		stx  zpa
		jsr  AYINT
		ldx  zpa
		lda  floats.AYINT_facmo
		sta  P8ESTACK_HI,x
		lda  floats.AYINT_facmo+1
		sta  P8ESTACK_LO,x
		dex
		rts
		.pend

stack_float2uw	.proc               ; also used for float2ub
		jsr  pop_float_fac1
		stx  zpa
		jsr  GETADR
		ldx  zpa
		sta  P8ESTACK_HI,x
		tya
		sta  P8ESTACK_LO,x
		dex
		rts
		.pend

push_float	.proc
		; ---- push mflpt5 in A/Y onto stack
		; (taking 3 stack positions = 6 bytes of which 1 is padding)
		sta  zpWord0
		sty  zpWord0+1
		ldy  #0
		lda  (zpWord0),y
		sta  P8ESTACK_LO,x
		iny
		lda  (zpWord0),y
		sta  P8ESTACK_HI,x
		dex
		iny
		lda  (zpWord0),y
		sta  P8ESTACK_LO,x
		iny
		lda  (zpWord0),y
		sta  P8ESTACK_HI,x
		dex
		iny
		lda  (zpWord0),y
		sta  P8ESTACK_LO,x
		dex
		rts
		.pend

pop_float	.proc
		; ---- pops mflpt5 from stack to memory A/Y
		; (frees 3 stack positions = 6 bytes of which 1 is padding)
		sta  zpWord0
		sty  zpWord0+1
		ldy  #4
		inx
		lda  P8ESTACK_LO,x
		sta  (zpWord0),y
		dey
		inx
		lda  P8ESTACK_HI,x
		sta  (zpWord0),y
		dey
		lda  P8ESTACK_LO,x
		sta  (zpWord0),y
		dey
		inx
		lda  P8ESTACK_HI,x
		sta  (zpWord0),y
		dey
		lda  P8ESTACK_LO,x
		sta  (zpWord0),y
		rts
		.pend

pop_float_fac1	.proc
		; -- pops float from stack into FAC1
		lda  #<fmath_float1
		ldy  #>fmath_float1
		jsr  pop_float
		lda  #<fmath_float1
		ldy  #>fmath_float1
		jmp  MOVFM
		.pend

copy_float	.proc
		; -- copies the 5 bytes of the mflt value pointed to by zpWord0,
		;    into the 5 bytes pointed to by A/Y.  Clobbers A,Y.
		sta  zpWord1
		sty  zpWord1+1
		ldy  #0
		lda  (zpWord0),y
		sta  (zpWord1),y
		iny
		lda  (zpWord0),y
		sta  (zpWord1),y
		iny
		lda  (zpWord0),y
		sta  (zpWord1),y
		iny
		lda  (zpWord0),y
		sta  (zpWord1),y
		iny
		lda  (zpWord0),y
		sta  (zpWord1),y
		rts
		.pend

inc_var_f	.proc
		; -- add 1 to float pointed to by A/Y
		sta  zpWord0
		sty  zpWord0+1
		stx  zpa
		jsr  MOVFM
		lda  #<FL_ONE_const
		ldy  #>FL_ONE_const
		jsr  FADD
		ldx  zpWord0
		ldy  zpWord0+1
		jsr  MOVMF
		ldx  zpa
		rts
		.pend

dec_var_f	.proc
		; -- subtract 1 from float pointed to by A/Y
		sta  zpWord0
		sty  zpWord0+1
		stx  zpa
		lda  #<FL_ONE_const
		ldy  #>FL_ONE_const
		jsr  MOVFM
		lda  zpWord0
		ldy  zpWord0+1
		jsr  FSUB
		ldx  zpWord0
		ldy  zpWord0+1
		jsr  MOVMF
		ldx  zpa
		rts
		.pend


pop_2_floats_f2_in_fac1	.proc
		; -- pop 2 floats from stack, load the second one in FAC1 as well
		lda  #<fmath_float2
		ldy  #>fmath_float2
		jsr  pop_float
		lda  #<fmath_float1
		ldy  #>fmath_float1
		jsr  pop_float
		lda  #<fmath_float2
		ldy  #>fmath_float2
		jmp  MOVFM
		.pend


fmath_float1	.byte 0,0,0,0,0	; storage for a mflpt5 value
fmath_float2	.byte 0,0,0,0,0	; storage for a mflpt5 value


push_fac1	.proc
		; -- push the float in FAC1 onto the stack
		stx  zpa
_internal	ldx  #<fmath_float1
		ldy  #>fmath_float1
		jsr  MOVMF
		lda  #<fmath_float1
		ldy  #>fmath_float1
		ldx  zpa
		jmp  push_float
		.pend

div_f		.proc
		; -- push f1/f2 on stack
		jsr  pop_2_floats_f2_in_fac1
		stx  zpa
		lda  #<fmath_float1
		ldy  #>fmath_float1
		jsr  FDIV
		jmp  push_fac1._internal
		.pend

add_f		.proc
		; -- push f1+f2 on stack
		jsr  pop_2_floats_f2_in_fac1
		stx  zpa
		lda  #<fmath_float1
		ldy  #>fmath_float1
		jsr  FADD
		jmp  push_fac1._internal
		.pend

sub_f		.proc
		; -- push f1-f2 on stack
		jsr  pop_2_floats_f2_in_fac1
		stx  zpa
		lda  #<fmath_float1
		ldy  #>fmath_float1
		jsr  FSUB
		jmp  push_fac1._internal
		.pend

mul_f		.proc
		; -- push f1*f2 on stack
		jsr  pop_2_floats_f2_in_fac1
		stx  zpa
		lda  #<fmath_float1
		ldy  #>fmath_float1
		jsr  FMULT
		jmp  push_fac1._internal
		.pend

neg_f		.proc
		; -- toggle the sign bit on the stack
		lda  P8ESTACK_HI+3,x
		eor  #$80
		sta  P8ESTACK_HI+3,x
		rts
		.pend

var_fac1_less_f	.proc
		; -- is the float in FAC1 < the variable AY?
		stx  zpa
		jsr  FCOMP
		ldx  zpa
		cmp  #255
		beq  +
		lda  #0
		rts
+		lda  #1
		rts
		.pend

var_fac1_lesseq_f	.proc
		; -- is the float in FAC1 <= the variable AY?
		stx  zpa
		jsr  FCOMP
		ldx  zpa
		cmp  #0
		beq  +
		cmp  #255
		beq  +
		lda  #0
		rts
+		lda  #1
		rts
		.pend

var_fac1_greater_f	.proc
		; -- is the float in FAC1 > the variable AY?
		stx  zpa
		jsr  FCOMP
		ldx  zpa
		cmp  #1
		beq  +
		lda  #0
		rts
+		lda  #1
		rts
		.pend

var_fac1_greatereq_f	.proc
		; -- is the float in FAC1 >= the variable AY?
		stx  zpa
		jsr  FCOMP
		ldx  zpa
		cmp  #0
		beq  +
		cmp  #1
		beq  +
		lda  #0
		rts
+		lda  #1
		rts
		.pend

var_fac1_notequal_f	.proc
		; -- are the floats numbers in FAC1 and the variable AY *not* identical?
		stx  zpa
		jsr  FCOMP
		ldx  zpa
		and  #1
		rts
		.pend

vars_equal_f	.proc
		; -- are the mflpt5 numbers in zpWord0 and AY identical?
		sta  zpWord1
		sty  zpWord1+1
		ldy  #0
		lda  (zpWord0),y
		cmp  (zpWord1),y
		bne  _false
		iny
		lda  (zpWord0),y
		cmp  (zpWord1),y
		bne  _false
		iny
		lda  (zpWord0),y
		cmp  (zpWord1),y
		bne  _false
		iny
		lda  (zpWord0),y
		cmp  (zpWord1),y
		bne  _false
		iny
		lda  (zpWord0),y
		cmp  (zpWord1),y
		bne  _false
		lda  #1
		rts
_false		lda  #0
		rts
		.pend

equal_f		.proc
		; -- are the two mflpt5 numbers on the stack identical?
		inx
		inx
		inx
		inx
		lda  P8ESTACK_LO-3,x
		cmp  P8ESTACK_LO,x
		bne  _equals_false
		lda  P8ESTACK_LO-2,x
		cmp  P8ESTACK_LO+1,x
		bne  _equals_false
		lda  P8ESTACK_LO-1,x
		cmp  P8ESTACK_LO+2,x
		bne  _equals_false
		lda  P8ESTACK_HI-2,x
		cmp  P8ESTACK_HI+1,x
		bne  _equals_false
		lda  P8ESTACK_HI-1,x
		cmp  P8ESTACK_HI+2,x
		bne  _equals_false
_equals_true	lda  #1
_equals_store	inx
		sta  P8ESTACK_LO+1,x
		rts
_equals_false	lda  #0
		beq  _equals_store
		.pend

notequal_f	.proc
		; -- are the two mflpt5 numbers on the stack different?
		jsr  equal_f
		eor  #1		; invert the result
		sta  P8ESTACK_LO+1,x
		rts
		.pend

vars_less_f	.proc
		; -- is float in AY < float in zpWord1 ?
		jsr  MOVFM
		lda  zpWord1
		ldy  zpWord1+1
		stx  zpa
		jsr  FCOMP
		ldx  zpa
		cmp  #255
		bne  +
		lda  #1
		rts
+		lda  #0
		rts
		.pend

vars_lesseq_f	.proc
		; -- is float in AY <= float in zpWord1 ?
		jsr  MOVFM
		lda  zpWord1
		ldy  zpWord1+1
		stx  zpa
		jsr  FCOMP
		ldx  zpa
		cmp  #255
		bne  +
-		lda  #1
		rts
+		cmp  #0
		beq  -
		lda  #0
		rts
		.pend

less_f		.proc
		; -- is f1 < f2?
		jsr  compare_floats
		cmp  #255
		beq  compare_floats._return_true
		bne  compare_floats._return_false
		.pend


lesseq_f	.proc
		; -- is f1 <= f2?
		jsr  compare_floats
		cmp  #255
		beq  compare_floats._return_true
		cmp  #0
		beq  compare_floats._return_true
		bne  compare_floats._return_false
		.pend

greater_f	.proc
		; -- is f1 > f2?
		jsr  compare_floats
		cmp  #1
		beq  compare_floats._return_true
		bne  compare_floats._return_false
		.pend

greatereq_f	.proc
		; -- is f1 >= f2?
		jsr  compare_floats
		cmp  #1
		beq  compare_floats._return_true
		cmp  #0
		beq  compare_floats._return_true
		bne  compare_floats._return_false
		.pend

compare_floats	.proc
		lda  #<fmath_float2
		ldy  #>fmath_float2
		jsr  pop_float
		lda  #<fmath_float1
		ldy  #>fmath_float1
		jsr  pop_float
		lda  #<fmath_float1
		ldy  #>fmath_float1
		jsr  MOVFM		; fac1 = flt1
		lda  #<fmath_float2
		ldy  #>fmath_float2
		stx  zpa
		jsr  FCOMP		; A = flt1 compared with flt2 (0=equal, 1=flt1>flt2, 255=flt1<flt2)
		ldx  zpa
		rts
_return_false	lda  #0
_return_result  sta  P8ESTACK_LO,x
		dex
		rts
_return_true	lda  #1
		bne  _return_result
		.pend

set_array_float_from_fac1	.proc
		; -- set the float in FAC1 in the array (index in A, array in zpWord0)
		sta  zpy
		asl  a
		asl  a
		clc
		adc  zpy
		ldy  zpWord0+1
		clc
		adc  zpWord0
		bcc  +
		iny
+		stx  floats_store_reg
		tax
		jsr  MOVMF
		ldx  floats_store_reg
		rts
		.pend


set_0_array_float	.proc
		; -- set a float in an array to zero (index in A, array in zpWord0)
		sta  zpy
		asl  a
		asl  a
		clc
		adc  zpy
		tay
		lda  #0
		sta  (zpWord0),y
		iny
		sta  (zpWord0),y
		iny
		sta  (zpWord0),y
		iny
		sta  (zpWord0),y
		iny
		sta  (zpWord0),y
		rts
		.pend


set_array_float		.proc
		; -- set a float in an array to a value (index in A, float in zpWord0, array in zpWord1)
		sta  zpy
		asl  a
		asl  a
		clc
		adc  zpy
		adc  zpWord1
		ldy  zpWord1+1
		bcc  +
		iny
+		jmp  copy_float
			; -- copies the 5 bytes of the mflt value pointed to by SCRATCH_ZPWORD1,
			;    into the 5 bytes pointed to by A/Y.  Clobbers A,Y.
		.pend


equal_zero	.proc
		jsr  floats.pop_float_fac1
		jsr  floats.SIGN
		beq  _true
		bne  _false
_true		lda  #1
		sta  P8ESTACK_LO,x
		dex
		rts
_false		lda  #0
		sta  P8ESTACK_LO,x
		dex
		rts
		.pend

notequal_zero	.proc
		jsr  floats.pop_float_fac1
		jsr  floats.SIGN
		bne  equal_zero._true
		beq  equal_zero._false
		.pend

greater_zero	.proc
		jsr  floats.pop_float_fac1
		jsr  floats.SIGN
		beq  equal_zero._false
		bpl  equal_zero._true
		jmp  equal_zero._false
		.pend

less_zero	.proc
		jsr  floats.pop_float_fac1
		jsr  floats.SIGN
		bmi  equal_zero._true
		jmp  equal_zero._false
		.pend

greaterequal_zero	.proc
		jsr  floats.pop_float_fac1
		jsr  floats.SIGN
		bpl  equal_zero._true
		jmp  equal_zero._false
		.pend

lessequal_zero	.proc
		jsr  floats.pop_float_fac1
		jsr  floats.SIGN
		beq  equal_zero._true
		bmi  equal_zero._true
		jmp  equal_zero._false
		.pend
        