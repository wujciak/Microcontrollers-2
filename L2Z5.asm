;
; l2z5.asm
; Jakub Wójciak 269321
;

.def temp = r16
.def process = r17
.def sim_process = r18
.def err = r19
.equ start_button = 6
.equ stop_button = 7

.org 0x00
jmp init
.org 0x46

init:
	ldi temp, high(ramend)
    out sph, temp
    ldi temp, low(ramend)
    out spl, temp

    ldi temp, 0xff ; Ustawienie wszystkich pinów portu C jako wyjścia
	out ddrc, temp
	out portc, temp

	ldi temp, 0x00 ; Ustawienie wszystkich pinów portu B jako wejścia
	out ddrb, temp

	ldi process, 0
    ldi sim_process, 0xff
	ldi err, 0b0111_1111

; S1 - Stan bez wybranego procesu
main: 
    in temp, pinb

	; Obsługa przycisków 0-2
	cpi temp, 0b1111_1110
    breq process_choosen
	cpi temp, 0b1111_1101
    breq process_choosen
	cpi temp, 0b1111_1011
    breq process_choosen

	; Niedozwolone operacje
    cpi temp, 0b1111_1000
    breq error
	cpi temp, 0b1111_1100
    breq error
	cpi temp, 0b1111_1001
    breq error
	cpi temp, 0b1111_1010
    breq error
	cpi temp, 0b0111_1111
    breq error
	cpi temp, 0b1011_1111
    breq error

	rjmp main
	
; S2 - Stan obsługi wyboranego procesu
process_choosen:
	mov process, temp
	out portc, process

wait_for_start_pressed:
	call delay
	in temp, pinb

	sbis pinb, start_button
	rjmp simulate_process

	sbis pinb, stop_button
    breq error

	sbic pinb, 0 | 1 | 2
	rjmp process_choosen

	rjmp wait_for_start_pressed

; S4 - Stan symulacji procesu
simulate_process:
	mov sim_process, process
	sec
	rol sim_process
	rol sim_process
	rol sim_process
	and sim_process, temp
    out portc, sim_process

wait_for_stop_pressed:
	sbic pinb, stop_button
	rjmp wait_for_stop_pressed

	rjmp process_choosen

; S3 - Stan obsługi błędu
error:
    out portc, err
	
	call delay

	in temp, pinb
	cpi temp, 0b1111_1110
    breq process_choosen
	cpi temp, 0b1111_1101
    breq process_choosen
	cpi temp, 0b1111_1011
    breq process_choosen

    rjmp error

delay:
 ldi r20, 0x40
 loop:
 ldi r21, 0x30
 loop1:
 ldi r22, 0xaf
 loop2:
 dec r22
 brne loop2
 dec r21
 brne loop1
 dec r20
 brne loop
 ret
