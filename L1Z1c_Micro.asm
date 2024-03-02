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

	ldi r16, 0xff
	out ddrc, r16

loop:
	ldi r16, 0xfe
	out portc, r16
	call delay

	ldi r16,0xfd
	out portc ,r16
	call delay

	rjmp petla

delay:
	ldi r18, 0xff
loop2:
	ldi r18, 0xff
loop3:
	dec r18
	brne loop3

	dec r18
	brne loop2
	ret
