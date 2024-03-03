;
; Autor: Jakub Wójciak
; Lista 1 
; Zadanie 1b
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

	ldi r19, 0x07

	rjmp loop

delay:	; 60Hz, żeby ludzkie oko nie widziało migania
	ldi r19, 0x10
loop2:
	dec r19
	brne loop2
	ret
