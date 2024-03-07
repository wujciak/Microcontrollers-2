;
; Autor: Jakub Wójciak
; Lista 1 
; Zadanie 1b
;
; Efekt stroboskopowy.
; Ten program działa dobrze tylko dla procesora 16MHz


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
	ldi r19, 0x18
loop2:
	dec r19
	brne loop2
	ret

