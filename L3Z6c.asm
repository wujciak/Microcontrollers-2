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
		int press_count = 0;
		
		for (int i = 0; i < 8; i++) {
			if ( !(button & (1 << i)) ) {
				press_count++;
			}
		}
		
		if (press_count == 1) {
			for (int i = 0; i < 8; i++) {
				if ( !(button & (1 << i)) ) {
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
