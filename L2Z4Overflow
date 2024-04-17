;
; L2Z4.asm
; Author : Jakub Wojciak 269321
;
; Wersja z przerwaniami Timer/Counter1 Overflow


jmp start
.org 0x1c	;Adres dla przerwania Timer/Counter1 Overflow
jmp interrupt
.org 0x46

start:
	ldi r16, high(ramend)
	out sph, r16
	ldi r16, low(ramend)
	out spl, r16

	ldi r16, 0xff
	out ddrc, r16

	;Konfiguracja Timer/Counter1 w trybie normalnym z prescalerem 256
	ldi r16, 0
	out tccr1a, r16
	ldi r16, 0b100	;1 = CS02, 0 = CS12, 0 = CS10
	out tccr1b, r16

	;Ustawiam początkową wartość Timer/Counter1 na 256*256 - (taktowanie zegara / prescaler) = 148 high i 128 low
	ldi r16, 149
	out tcnt1h, r16
	ldi r16, 128
	out tcnt1l, r16

	;Ustawienie przerwań dla overflow Timer/Counter1
	ldi r16, 0b0100	;1 = TOIE1, ; Enable Timer/Counter1 Overflow interrupt
	out timsk, r16

	ldi r17, 0x00

	sei 

loop: 
	jmp loop

interrupt:
 	inc r17
	com r17
	out portc, r17
	com r17

	ldi r16, 149
	out tcnt1h, r16
	ldi r16, 128
	out tcnt1l, r16
	
	reti
