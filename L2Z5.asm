;
; l2z5.asm
; Jakub Wójciak 269321
;

.def temp = r16
.def process = r17
.def sim_process = r18
.def err = r19

.org 0x00
jmp init
.org 0x46

init:
	ldi temp, high(ramend)
    out sph, temp
    ldi temp, low(ramend)
    out spl, temp

    ldi temp, 0xff
	out ddrc, temp
	out portc, temp

	ldi temp, 0x00
	out ddrb, temp

	ldi process, 0
    ldi sim_process, 0xff
	ldi err, 0b0111_1111

main: ;S1
	; Odczytaj stan przycisków
    in temp, pinb

	;Obsługa przycisków 0-2
	cpi temp, 0b1111_1110
    breq process_choosen
	cpi temp, 0b1111_1101
    breq process_choosen
	cpi temp, 0b1111_1011
    breq process_choosen

	;Niedozwolone operacje
    cpi temp, 0b1111_1000
    breq error
	cpi temp, 0b0111_1111
    breq error
	cpi temp, 0b1011_1111
    breq error

	rjmp main
	
process_choosen: ;S2
	mov process, temp
	out portc, process

	sbis pinb, 6
    breq error

wait_for_start_pressed:
	sbic pinb, 7
	rjmp wait_for_start_pressed
	rjmp simulate_process

simulate_process: ;S4
	mov sim_process, process
	sec
	rol sim_process
	rol sim_process
	rol sim_process
	and sim_process, temp
    out portc, sim_process

wait_for_stop_pressed:
	sbic pinb, 6
	rjmp wait_for_stop_pressed
	rjmp process_choosen

error: ;S3
    out portc, err
    rjmp error
