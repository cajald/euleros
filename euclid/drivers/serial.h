/*
 * serial.h -- serial port
 *
 * The serial port UART interface is a pretty old communication
 * interface using PMIO.
 *
 * It's pretty convenient for lots of things: communicating events, debugging,
 * ...
 *
 * Additionally, scripts/emul.ksh prints serial output to stdout too.
 *
 * The bad thing is that there is not clock wire, so we just kinda agree
 * on common parameters, here I used 115200 8N1 on COM 1:
 *
 * 	- 115200 baud rate
 * 	- 8 data bits
 *      - No parity
 *      - 1 stop bit
 *
 * Yes, they are hard coded :).
 */

#ifndef SERIAL_H
#define SERIAL_H

/*** constants ***/

/*** functions ***/

void serial_setup(void);
void serial_putch(char ch);
void serial_puts(const char* s);
void serial_printf(const char* fmt, ...);

#endif /* SERIAL_H */

