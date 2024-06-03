#include <avr/io.h>

void setup(void) {
	DDRB = 0x00;
	DDRC = 0xff;
	PORTC = 0xff;
}

int main(void) {
	setup();
	
	while(1) {
		int button = PINB;
		
		if (button != 0xff) {
			for (int i = 7; i >= 0; i--) {
				if (!(button & (1 << i))) {
					PORTC = ~(1 << i);
					break;
				}
			}
			} else {
				PORTC = 0xff;
			}
		}
		
		return 0;
	}
