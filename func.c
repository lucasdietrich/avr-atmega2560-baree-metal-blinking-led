#include <util/delay.h>

#define PERIOD_MS 50U

void delay(void)
{
    _delay_ms(PERIOD_MS);
}