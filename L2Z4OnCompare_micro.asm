;
; L2Z4.asm
; Author : Jakub Wojciak 269321
;
; Wersja z przerwaniami Timer/Counter1 Compare Match


jmp start
.org 0x18	;Adres dla przerwania Timer/Counter1 Compare Match A
jmp interrupt
.org 0x46

start:
	ldi r16, high(ramend)
	out sph, r16
	ldi r16, low(ramend)
	out spl, r16

	ldi r16, 0xff
	out ddrc, r16

	;Konfiguracja Timer/Counter1 w trybie CTC z prescalerem 1024
	ldi r16, 0
	out tccr1a, r16
	ldi r16, 0b1101	;(1 = WGM12), (1 = CS02, 0 = CS12, 1 = CS10)
	out tccr1b, r16

	;Ustawienie wartości dla odliczania sekundy (16-bitowy rejestr porównawczy)
	ldi r16, 0x1d
	out ocr1ah, r16
	ldi r16, 0x04
	out ocr1al, r16

	;Ustawienie przerwań
	ldi r16, 0b10000	;1 = OCIE1B, Enable Timer/Counter1 Compare Match B interrupt
	out timsk, r16

	ldi r17, 0xff
	out portc, r17
	com r17

	sei 

loop: 
	jmp loop

interrupt:
	inc r17
	com r17
	out portc, r17
	com r17
	reti
