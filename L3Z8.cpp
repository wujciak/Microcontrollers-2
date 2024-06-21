#define F_CPU 7000000UL
#include <avr/io.h>
#include <util/delay.h>


int counter = 0;

void setup(void) {
	DDRB = 0xfc;
	DDRC = 0xff;
	PORTC = 0xff;
}

// odczyt dodawania przez PB1
int debounce_add(void) {
	if (~PINB & 0b00000010) {
		_delay_ms(50);
		if (~PINB & 0b00000010) {
			return 1;
		}
	}
	return 0;
}

// odczyt odejmowania przez PB0
int debounce_sub(void) {
	if (~PINB & 0b00000001) {
		_delay_ms(50);
		if (~PINB & 0b00000001) {
			return 1;
		}
	}
	return 0;
}


int main(void) {
	setup();
	while (1) {
		if (debounce_add()) {
			while (~PINB & 0b00000010); 
			counter++;
			PORTC = ~counter;
		}
		if (debounce_sub()) {
			while (~PINB & 0b00000001);
			counter--;
			PORTC = ~counter;
		}
	}
	return 0;
}
