;
; Autor: Jakub Wójciak
; Lista 1 
; Zadanie 1c
;

rjmp main
.org 0x46

main:
	ldi r16, low(ramend)	
	out spl, r16
	ldi r16, high(ramend)
	out sph, r16

	ldi zl, low(delay)
	ldi zh, high(delay)

	ldi xl, low(delay2)
	ldi xh, high(delay2)

	ldi r16, 0xff
	out ddrc, r16

loop:
	ldi r16, 0xfe
	out portc, r16
	call delay

	ldi r16, 0xff
	out portc, r16
	call delay2

	ldi r16,0xfd
	out portc ,r16
	call delay

	ldi r16, 0xff
	out portc, r16
	call delay2


	rjmp loop

delay:
	ldi r19, 0x05
loop2:
	dec r19
	brne loop2
	ret

delay2:
	ldi r18, 0x10
loop3:
	dec r18
	brne loop3
	ret
