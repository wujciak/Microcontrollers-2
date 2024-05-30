;
; l2z5.asm
; Jakub Wójciak 269321
;

.def temp = r16
.def process = r17
.def sim_process = r18
.def err = r19
.equ start_button = 7
.equ stop_button = 6

.org 0x00
jmp init
.org 0x46

; Opóźnienie do debouncingu
debounce_delay:
    ldi r20, 0xff
    ldi r21, 0xff
debounce_loop:
    dec r21
    brne debounce_loop
    dec r20
    brne debounce_loop
    ret

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
    ldi err, 0b1000_0000

; S1 - Stan bez wybranego procesu
main:
    in temp, pinb

    ; Sprawdzanie błędnych kombinacji przycisków
    cpi temp, 0b0111_1111 ; Niedozwolone kombinacje z PB6 lub PB7
    brlo check_single_buttons
    rjmp error

check_single_buttons:
    ; Sprawdzanie pojedynczych przycisków 0-2
    cpi temp, 0b1111_1110
    breq process_chosen
    cpi temp, 0b1111_1101
    breq process_chosen
    cpi temp, 0b1111_1011
    breq process_chosen

    rjmp main

; S2 - Stan po poprawnym wybraniu procesu
process_chosen:
    mov process, temp
    out portc, process
    rcall debounce_delay

wait_for_start:
    in temp, pinb
    sbic pinb, start_button
    rjmp wait_for_start
    rcall debounce_delay

    rjmp simulate_process

; S4 - Stan cyklicznego wykonywania wybranego procesu
simulate_process:
    ; Zapalenie odpowiedniej diody (bity 3-5)
    mov sim_process, process
    sec
    rol sim_process
    rol sim_process
    rol sim_process
    andi sim_process, 0b0011_1000
    out portc, sim_process
    rcall debounce_delay

wait_for_stop:
    in temp, pinb
    sbic pinb, stop_button
    rjmp wait_for_stop
    rcall debounce_delay

    rjmp stop_process

; S42 - Stan po zatrzymaniu procesu
stop_process:
    out portc, process
    rjmp main

; S3 - Stan po niepoprawnym wyborze
error:
    out portc, err
    rcall debounce_delay

wait_for_valid_input:
    in temp, pinb
    cpi temp, 0b1111_1110
    breq process_chosen
    cpi temp, 0b1111_1101
    breq process_chosen
    cpi temp, 0b1111_1011
    breq process_chosen

    rjmp wait_for_valid_input
