#include <avr/io.h>
#include <avr/interrupt.h>

volatile int pwm_counter = 0;
volatile int pwm_threshold = 10;

void setup(void) {
	DDRC = 0xff;
	PORTC = 0xfe;

	TCCR1A = 0;
	TCCR1B = (1 << WGM12) | (1 << CS12); // CTC mode, prescaler 256
	OCR1A = 50;    // (t * f)/(prescaler * 1s)  t = 1s, f = 7MHz, prescaler = 256
	TIMSK |= (1 << OCIE1A);

	sei();
}

ISR(TIMER1_COMPA_vect) {
	pwm_counter++;
	if (pwm_counter >= pwm_threshold) {
		pwm_counter = 0;
		if (PORTC == 0xfe) {
			PORTC = 0xfd;
			} else {
			PORTC = 0xfe;
		}
		} else {
		PORTC = 0xfd;
	}
}

int main(void) {
	setup();
	while (1) {
	}
	return 0;
}
