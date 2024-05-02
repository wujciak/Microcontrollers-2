;
; Autor: Jakub Wójciak
; Lista 1 
; Zadanie 3
;

.cseg
rjmp start
.org 0x46

start:
	ldi r16, low(ramend)
	out spl, r16
	ldi r16, high(ramend)
	out sph, r16

	ldi r16, 0x00
	out ddrb, r16

	ldi r16, 0xff
	out ddrc, r16
	out portc, r16

	ldi r16, 0xff
	ldi r19, 0x00	;licznik

main_loop:
    	call read_stable	;odczekaj około 41ms

	cpi r17, 0xff
	breq main_loop

	sbrc r17, 3
	inc r19
	sbrc r17, 7
	dec r19

	eor r19, r16
    	out portc, r19
	eor r19, r16
read:
	call read_stable
	cpi r17, 0xff
	breq main_loop
    rjmp read

read_stable:
	in r17, pinb	;stan bieżący do pinb

	delay:
		ldi r23, 0xff/2
	delay_loop:
		ldi r22, 0xff
	delay_loop2:
		ldi r21, 0x01
	delay_loop3:
		dec r21
		brne delay_loop3
		dec r22
		brne delay_loop2
		dec r23
		brne delay_loop

		mov r18, r17	;zapisuje stan przycisku do porownania
		in r17, pinb	;stan bieżący do pinb
		cp r18, r17	;porównanie stanu poprzedniego i bieżącego
		brne delay
    ret
