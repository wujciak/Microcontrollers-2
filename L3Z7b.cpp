#include <avr/io.h>
#include <avr/interrupt.h>


volatile int delay_ms = 1000;

void setup(void) {
	DDRC = 0xff;
	PORTC = 0xfe;

	TCCR1A = 0;
	TCCR1B = (1 << WGM12) | (1 << CS12);
	OCR1A = 27343;	// (t * f)/(prescaler * 1s)  t = 1s, f = 7MHz, prescaler = 256
	TIMSK |= (1 << OCIE1A);
	
	sei();
}

ISR(TIMER1_COMPA_vect) {
	if (PORTC == 0xfe) {
		PORTC = 0xfd;
		} else {
		PORTC = 0xfe;
	}
	
	if (delay_ms > 20) {
		delay_ms -= 40;
		OCR1A -= 1093;	// ~40ms
	}
	
}

int main(void) {
	setup();
	
	while(1) {
		
	}
	
	return 0;
}
