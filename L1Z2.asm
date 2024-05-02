;
; Autor: Jakub Wójciak
; Lista 1 
; Zadanie 2
;

.cseg
rjmp main
.org 0x1fe

tablica: .db 0b00001111, 0b00000011, 0b00000000, 0b00010011, 0b00000100, 0b01100101, 0b01000110, 0b00000111, 0b00001000, 0b00001001, 0b00001010, 0b00001011, 0b00001100, 0b00001101, 0b00001110, 0b00001111

main:
	ldi r16, 0xff
	out ddrc, r16
	out portc, r16

	ldi r16, 0x00
	out ddrb, r16

	ldi r16, 0xff
	ldi r17, 0xff

loop:
	ldi zl, low(tablica<<1)
	ldi zh, high(tablica<<1)

	in r18, pinb

	cpi r18, 0xff
	brbs 1, none

	eor r18, r17
	cpi r18, 0x10
	brbc 0, none
 
	dec r18
	add zl, r18
	ldi r16, 0
	adc zh, r16
	lpm r16, z
	eor r16, r17
	out portc, r16

	rjmp loop

none:
	ldi r16, 0xff
	out portc, r16
	rjmp loop
