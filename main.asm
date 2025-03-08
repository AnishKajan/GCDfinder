;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .data                           ; Assemble into data memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have


LENGTH: 	.set 2*5

; Comment and uncomment definitions as needed
; for debugging, different levels etc.
; You can use this set of numbers for easier debugging
;x_array:	.word 	12, 13, 11, 45, 15
;y_array: 	.word 	20, 31, 11, 54, 75

; Submit your results for this set of numbers !!!
x_array:	.word 	2448, 1505,  4424, 14217, 38689
y_array: 	.word 	3344, 5565, 29061,  6042, 12461

; For the Challenge Level use these arrays
;x_array:	.long 	1505, 164240, 96523,  70274, 5649201
;y_array: 	.long 	5565, 164256,  8529, 856273, 4587273
;d_array:	.space 	2*LENGTH

; Your results will be displayed in these arrays
d_array:	.space 	LENGTH
s_array:	.space 	LENGTH
t_array:	.space 	LENGTH

;-------------------------------------------------------------------------------

            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

			clr.w	R7
			clr.w	R8
			clr.w	R9
			clr.w	R10
			clr.w	R11
			clr.w	R13
			clr.w	R14
			clr.w	R15 					;


			mov.w	#LENGTH-2, R4			; init index R4

next:
			mov.w	x_array(R4), R5			; prepare the input
			mov.w	y_array(R4), R6

			call 	#gcd 					; run with this line for Level 1
;			call 	#gcd_plus_st			; run with this line for Level 2
;			call 	#gcd_32 				; for the challenge level you also
											; must modify the test code

			mov.w   R12, d_array(R4)		; take the output
			mov.w	R14, s_array(R4)
			mov.w	R15, t_array(R4)

			decd.w	R4
			jge 	next


end: 		jmp		end
			nop


;-------------------------------------------------------------------------------
; Subroutine: gcd
;
; Inputs: unsigned 16-bit integer x > 0 in R5 -- returned unmodified
;         unsigned 16-bit integer y > 0 in R6 -- returned unmodified
;
; Output: unsigned 16-bit integer d = gcd(x,y) in R12
;
; Subroutine modifies R12
; No other core register in R4-R15 is modified
; Subroutine does not access any addressed memory locations
;-------------------------------------------------------------------------------
gcd:
			push.w	R5
			push.w	R6
loop_gcd:
    		cmp.w   R6, R5              ; Compare R6 and R5
    		jeq		finish				; gcd is found when R6 and R5 are equal
    		jhs     greater_R5
    		jl		greater_R6

greater_R6:
			sub.w	R5, R6				; subtract R6 from R5 to reduce the amount
			jmp		loop_gcd			; jump back to compare

greater_R5:
    		sub.w   R6, R5
    		jmp     loop_gcd

finish:
			mov.w	R5, R12				; store gcd value
    		pop.w	R6
    		pop.w	R5
    		ret                         ; Return from subroutine
;-------------------------------------------------------------------------------
; Subroutine: gcd_plus_st
;
; Inputs: unsigned 16-bit integer x > 0 in R5 -- returned unmodified
;         unsigned 16-bit integer y > 0 in R6 -- returned unmodified
;
; Output: unsigned 16-bit integer d = gcd(x,y) in R12
;		  signed 16-bit integer s in R14
;		  signed 16-bit integer t in R15
;
; 		  where s and t are signed integers such that
;
; 				s*x + t*y = gcd(x,y)
;
; Subroutine modifies R12, R14, and R15
; No other core register in R4-R15 is modified
; Subroutine does not access any addressed memory locations
;-------------------------------------------------------------------------------
gcd_plus_st:
			push.w	R5
			push.w	R6

			mov.w	#1, R14			;new
			mov.w	#1, R15			;new

loop_gcd_2:
			cmp.w	R6, R5
			jeq		Finish
			jhs		greater_R5_2
			jlo		greater_R6_2

greater_R5_2:
			sub.w	R6, R5
			sub.w	R14, R15		;new
			jmp		loop_gcd_2

greater_R6_2:
			sub.w	R5, R6
			sub.w	R15, R14		;new
			jmp		loop_gcd_2

Finish:
			mov.w	R5, R12
			pop.w	R6
			pop.w	R5
			ret
;-------------------------------------------------------------------------------
; Subroutine: gcd_32
;
; Inputs: unsigned 32-bit integer x > 0 in R5, R6 -- returned unmodified
;         unsigned 32-bit integer y > 0 in R7, R8 -- returned unmodified
;
; Output: unsigned 32-bit integer d = gcd(x,y) in R12, R13
;
; Subroutine modifies R12 and R13
; No other core register in R4-R15 is modified
; Subroutine does not access any addressed memory locations
;-------------------------------------------------------------------------------
gcd_32:

; Are you up for a challenge?




;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
