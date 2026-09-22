/*
 * serial.c -- serial port
 *
 * See serial.h's description :)
 */

#define STB_SPRINTF_IMPLEMENTATION
#include <stb/stb_sprintf.h>
#include <asmutil.h>
#include "serial.h"

#define COM1 0x3f8
#define SERIAL_DATA (COM1+0)
#define SERIAL_IER  (COM1+1)
#define SERIAL_FIFO (COM1+2)
#define SERIAL_LCR  (COM1+3)
#define SERIAL_MCR  (COM1+4)
#define SERIAL_LSR  (COM1+5)

#define LSR_THRE 0x20
#define LCR_8N1  0x03
/*
 * For a standard PC UART clock of 1.8432 MHz:
 *
 *   divisor = 1843200 / (16 * baud)
 *           = 1843200 / (16 * 115200)
 *           = 1
 */
#define SERIAL_DIVISOR 1

/*** functions ***/

void
serial_setup(void)
{
	outb(SERIAL_IER, 0x00); /* disable interrupts */
	outb(SERIAL_LCR, 0x80); /* enable divisor latch */
	/* 115200 baud */
	outb(SERIAL_DATA, 0x01);
	outb(SERIAL_IER, 0x00);

	outb(SERIAL_LCR, LCR_8N1); /* 8N1 */
	outb(SERIAL_FIFO, 0xC7); /* enable fifo and clearr rx/tx fifos */
	outb(SERIAL_MCR, 0x03); /* enable dtr and rts */
}

void
serial_putch(char ch)
{
	/* wait till controller's ready */
	while (!(inb(SERIAL_LSR) & LSR_THRE))
		;;
	outb(SERIAL_DATA, (uint8_t)ch);

}

void
serial_puts(const char* s)
{
	while (*s) {
		if (*s == '\n')
			serial_putch('\r');
		serial_putch(*s++);
	}
}

void
serial_printf(const char* fmt, ...)
{
	char buf[1024];
	va_list ap;
	va_start(ap, fmt);
	int len = stbsp_vsnprintf(buf, sizeof(buf), fmt, ap);
	va_end(ap);

	if (len <= 0)
		return;
	if (len >= (int)sizeof(buf))
		len = sizeof(buf) - 1;

	for (int i = 0; i < len; i++)
		serial_putch(buf[i]);
}

