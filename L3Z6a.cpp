#include <avr/io.h>

void setup(void) {
	DDRB = 0x00;
	DDRC = 0xff;
	PORTC = 0xff;
}

int main(void) {
	setup();
    while(1) {
        PORTC = PINB;
    }
	
	return 0;
}
