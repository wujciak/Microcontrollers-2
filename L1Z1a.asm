;
; Autor: Jakub Wójciak
; Lista 1 
; Zadanie 1a
;
; Świecenie diod LED na zmianę przez 1s.
; Ten program działa dobrze tylko dla procesora 16MHz.

rjmp main
.org 0x46

main:
	ldi r16, low(ramend)	
	out spl, r16
	ldi r16, high(ramend)
	out sph, r16

	ldi r16, 0xff
	out ddrc, r16

loop:
	ldi r16, 0xfe
	out portc, r16
	call delay

	ldi r16,0xfd
	out portc ,r16
	call delay

	rjmp loop

delay:
	ldi r19, 0x54
loop2:
	ldi r18, 0xf9
loop3:
	ldi r17, 0xfe
loop4:
	dec r17
	brne loop4
	dec r18
	brne loop3
	dec r19
	brne loop2
	ret
