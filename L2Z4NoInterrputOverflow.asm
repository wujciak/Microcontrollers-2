;
; L2Z4.asm
; Author : Jakub Wojciak 269321
;
; Wersja bez przerwań z Timer/Counter1 Overflow

jmp start

start:
    ldi r16, 0xff
    out ddrc, r16

    ;Konfiguracja Timer/Counter1 w trybie normalnym z prescalerem 256
    ldi r16, 0
    out tccr1a, r16
    ldi r16, 0b100    ; CS02 = 1, CS01 = 0, CS00 = 0
    out tccr1b, r16

    ;Ustawienie początkowej wartości Timer/Counter1 na 148 high i 128 low
    ldi r16, 149
    out tcnt1h, r16
    ldi r16, 128
    out tcnt1l, r16

    ldi r17, 0x00

loop:
    ;Sprawdzam czy Timer/Counter1 osiągnął overflow
    in r16, tifr
    cpi r16, 0b100
    brne loop

    ;Jeśli Timer/Counter1 osiągnął wartość przepełnienia, inkrementujemy stan licznika
    inc r17
    com r17
    out portc, r17
    com r17

	ldi r16, 0b100
	out tifr, r16

    ;Ponowne ustawienie początkowej wartości Timer/Counter1 na 148 high i 128 low
    ldi r16, 149
    out tcnt1h, r16
    ldi r16, 128
    out tcnt1l, r16

    rjmp loop 

