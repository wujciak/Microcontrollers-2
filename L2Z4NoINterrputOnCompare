;
; L2Z4.asm
; Author : Jakub Wojciak 269321
;
; Wersja bez przerwan Timer/Counter1 Compare Match


jmp start

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
    ldi r16, 0b1101    ; WGM12 = 1, CS02 = 1, CS12 = 0, CS10 = 1
    out tccr1b, r16

    ; Ustawienie wartości dla odliczania sekundy (16-bitowy rejestr porównawczy)
    ldi r16, 0x1b
    out ocr1ah, r16
    ldi r16, 0x04
    out ocr1al, r16

    ldi r17, 0x00

loop:
    ;Sprawdzenie, czy flaga porównania Timer/Counter1 jest ustawiona
    in r16, tifr
    sbrc r16, ocf1a    ;Timer/Counter1 Compare Match Flag
    rjmp compare_match 

    rjmp loop

compare_match:
    ; Wykonywanie operacji po zdarzeniu porównania Timer/Counter1
    inc r17
    com r17
    out portc, r17
    com r17

    ; Resetowanie flagi porównania Timer/Counter1
    ldi r16, 0b10000    ;Ustawienie bitu OCF1A w rejestrze TIFR, zerowanie flagi
    out tifr, r16

    rjmp loop
