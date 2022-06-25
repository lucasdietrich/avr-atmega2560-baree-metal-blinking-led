#include <avr/io.h>

#if defined(__AVR_ATmega2560__)
#	define LED_DDR DDRB
#	define LED_PORT PORTB
#	define LED_PIN 7U
#else
#	error "Unsupported MCU"
#endif

extern void delay(void);

int main(void)
{
	LED_DDR |= _BV(LED_PIN);
	LED_PORT &= ~_BV(LED_PIN);

	for (;;) {
		LED_PORT |= _BV(LED_PIN);
		delay();
		LED_PORT &= ~_BV(LED_PIN);
		delay();
	}
}