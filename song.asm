page 60,132
;--------------------------------------------------------------------------
; Description: This program plays a scale from C4 to C5 twice, 1st in 1/4 time and then once again in 1/8 time.
;--------------------------------------------------------------------------

;-----------------------------------------------------------------------
;stack segment

sseg      segment para stack 'stack'
          db   120 dup(?)    				;reserve 120 bytes for the stack
sseg      ends

;-----------------------------------------------------------------------


;-----------------------------------------------------------------------
;data segment

dseg    segment para 'data'

	loop2number	DW	?
	loop1number	Dw	?

	;digital values that line up closest with associated musical notes
	noteC4 Dw  4560d
	noteD4 Dw  4063d
	noteE4 Dw  3619d
	noteF4 Dw  3416d
	noteG4 Dw  3043d
	noteA4 Dw  2711d
	noteB4b Dw 2559d
	noteC5 Dw  2280d

	songloop db 2

dseg    ends
 
;----------------------------------------------------------------------
;code segment
cseg      segment para 'code'

main    proc far               				;this is the program entry point
        assume cs:cseg, ds:dseg, ss:sseg 
        mov  ax,dseg           				;load the data segment value
        mov  ds,ax             				;assign value to ds
	
	in al,61h 					;Set AL to the value of speaker
	push ax  					;push it on the stack so we can restore to it later
	or al,00000011b 			;Revert the LSBs
	out 61h,al 					;Speaker turned on

	;First Round, c4 - c5 Quarter notes
	mov ax, noteC4				;Place the 16 bit value of noteC4 in ax
	out 42h, al					;Output bits 0-7 (less significant half) of noteC4 (stored in ax) to the speaker 
	mov al, ah					;Overwrite the al register with bits 8-15 (more significant half) of noteC4 
	out 42h, al					;Output bits 8-15 (more significant half) of noteC4 (stored in ax) to the speaker 
	call Quarter					;allow noteC4 to be played for a 1/4th time unit

	mov ax, noteD4
	out 42h, al
	mov al, ah
	out 42h, al
	call Quarter					;allow noteD4 to be played for a 1/4th time unit 
	
	mov ax, noteE4
	out 42h, al
	mov al, ah
	out 42h, al
	call Quarter					;allow noteE4 to be played for a 1/4th time unit

	mov ax, noteF4
	out 42h, al
	mov al, ah
	out 42h, al
	call Quarter					;allow noteF4 to be played for a 1/4th time unit

	mov ax, noteG4
	out 42h, al
	mov al, ah
	out 42h, al
	call Quarter					;allow noteG4 to be played for a 1/4th time unit

	mov ax, noteA4
	out 42h, al
	mov al, ah
	out 42h, al
	call Quarter					;allow noteA4 to be played for a 1/4th time unit
	
	mov ax, noteB4
	out 42h, al
	mov al, ah
	out 42h, al
	call Quarter					;allow noteB4 to be played for a 1/4th time unit
	
	mov ax, noteC5
	out 42h, al
	mov al, ah
	out 42h, al
	call Quarter					;allow noteC5 to be played for a 1/4th time unit
	
	;2nd Round, c4 - c5 Eighth notes
	mov ax, noteC4				
	out 42h, al					
	mov al, ah					
	out 42h, al					
	call Eighth					;allow noteC4 to be played for a 1/8th time unit

	mov ax, noteD4
	out 42h, al
	mov al, ah
	out 42h, al
	call Eighth					;allow noteD4 to be played for a 1/8th time unit 
	
	mov ax, noteE4
	out 42h, al
	mov al, ah
	out 42h, al
	call Eighth					;allow noteE4 to be played for a 1/8th time unit

	mov ax, noteF4
	out 42h, al
	mov al, ah
	out 42h, al
	call Eighth					;allow noteF4 to be played for a 1/8th time unit

	mov ax, noteG4
	out 42h, al
	mov al, ah
	out 42h, al
	call Eighth					;allow noteG4 to be played for a 1/8th time unit

	mov ax, noteA4
	out 42h, al
	mov al, ah
	out 42h, al
	call Eighth					;allow noteA4 to be played for a 1/8th time unit
	
	mov ax, noteB4
	out 42h, al
	mov al, ah
	out 42h, al
	call Eighth					;allow noteB4 to be played for a 1/8th time unit
	
	mov ax, noteC5
	out 42h, al
	mov al, ah
	out 42h, al
	call Eighth					;allow noteC5 to be played for a 1/8th time unit
	
jmp end



;**************************** Eighth Note
Eighth Proc NEAR	
	mov loop1number, 3
	mov loop2number, 40000

loop1: 
	mov loop2number, 40000

loop2:
	nop
	nop
	sub loop2number, 1
	cmp loop2number, 0
	jne loop2

	nop
	nop
	sub loop1number, 1
	cmp loop1number, 0
	jne loop1
	
	call Rest
	
	ret

Eighth endp
;******************************




;**************************** Quarter Note	
Quarter Proc NEAR
	mov loop1number, 4

loop3: 
	mov loop2number, 65000

loop4:
	nop
	nop
	sub loop2number, 1
	cmp loop2number, 0
	jne loop4

	nop
	nop
	sub loop1number, 1
	cmp loop1number, 0
	jne loop3

	call Rest

	ret

Quarter endp
;******************************  




;**************************** Half Note
Half Proc NEAR	
	mov loop1number, 8

loop5: 
	mov loop2number, 65000

loop6:
	nop
	nop
	sub loop2number, 1
	cmp loop2number, 0
	jne loop6

	nop
	nop
	sub loop1number, 1
	cmp loop1number, 0
	jne loop5

	call Rest	

	ret
Half endp
;******************************




;**************************** Rest
Rest Proc NEAR

	mov al, 255d
	out 42h, al
	out 42h, al	

	mov loop1number, 4
	mov loop2number, 7000


loop7:  mov loop2number, 7000

loop8:
	nop
	nop
	sub loop2number, 1
	cmp loop2number, 0
	jne loop8

	nop
	nop
	sub loop1number, 1
	cmp loop1number, 0
	jne loop7

	ret

Rest endp

;******************************



end:

	pop ax 				   		;get original speaker status
	and al,11111100b 	   		;clear lowest 2 bits
	out 61h,al			   		;turn speaker off

    	mov  ah,4Ch            	;set up interupt
    	int  21h               	;Interupt to return to DOS



main      endp
cseg      ends
          end     main           ;Program exit point




