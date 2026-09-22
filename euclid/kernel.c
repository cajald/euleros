/*
 * kernel.c -- entry, but now in C I guess
 */

#include "drivers/serial.h"

void
kmain(void)
{
	serial_setup();
	serial_printf("Euclid v%s started.\n", VERSION);
}

