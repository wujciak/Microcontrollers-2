;
; l2z5.asm
; Jakub Wójciak 269321
;

.def temp = r16
.def process = r17
.def temp2 = r18
.def err = r19
.equ stop_button = 6
.equ mask = 0b11000111

.org 0x00
jmp init
.org 0x46

; podprogram opóźnienia
debounce_delay:
    ldi r20, 0xFF
    ldi r21, 0xFF
    ldi r22, 0x01
delay_loop:
    dec r21
    brne delay_loop
    dec r20
    brne delay_loop
    dec r22
    brne delay_loop
    ret

; podprogram symulacji procesu
sim:
	cpi process, 0b11111110
	breq sim_process1
	cpi process, 0b11111101
	breq sim_process2
	cpi process, 0b11111011
	breq sim_process3
	sim_process1:
		ldi temp, 0b11110110
		out portc, temp
		ret
	sim_process2:
		ldi temp, 0b11101101
		out portc, temp
		ret
	sim_process3:
		ldi temp, 0b11011011
		out portc, temp
		ret

init:
    ldi temp, high(ramend)
    out sph, temp
    ldi temp, low(ramend)
    out spl, temp

    ldi temp, 0xFF ; wyjście
    out ddrc, temp
    out portc, temp

    ldi temp, 0x00 ; wejście
    out ddrb, temp

    ldi process, 0
    ldi err, 0b01111111

; S1 - Stan bez wybranego procesu
main:
    in temp, pinb
	rcall debounce_delay
	andi temp, mask
	cpi temp, mask
	breq main
   
	cpi temp, 0b11000110
	ldi process, 0b11111110
	breq process_choosen
	cpi temp, 0b11000101
	ldi process, 0b11111101
	breq process_choosen
	cpi temp, 0b11000011
	ldi process, 0b11111011
	breq process_choosen

	rjmp error

; S2 - Stan po poprawnym wybraniu procesu
process_choosen:
    out portc, process
	in temp, pinb
	rcall debounce_delay
	andi temp, mask
	cpi temp, mask
    breq process_choosen

	cpi temp, 0b01000111
	breq simulate_process

    cpi temp, 0b11000110
	ldi process, 0b11111110
	breq process_choosen
	cpi temp, 0b11000101
	ldi process, 0b11111101
	breq process_choosen
	cpi temp, 0b11000011
	ldi process, 0b11111011
	breq process_choosen

; S3 - Stan po niepoprawnym wyborze
error:
    out portc, err

    in temp, pinb
	rcall debounce_delay

	cpi temp, 0b11000110
	ldi process, 0b11111110
	breq process_choosen
	cpi temp, 0b11000101
	ldi process, 0b11111101
	breq process_choosen
	cpi temp, 0b11000011
	ldi process, 0b11111011
	breq process_choosen

    rjmp error

; S4 - Stan cyklicznego wykonywania wybranego procesu
simulate_process:
    ; Zapalenie odpowiedniej diody (bity 3-5)
    call sim
	in temp, pinb
	rcall debounce_delay
	andi temp, mask
	cpi temp, mask
	breq simulate_process

wait_for_stop:
    in temp, pinb
	rcall debounce_delay
	in temp2, pinb
	andi temp, mask
	andi temp2, mask
	cp temp, temp2
	brne wait_for_stop

	sbis pinb, stop_button
    rjmp process_choosen

	rjmp process_choosen
