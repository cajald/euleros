/*
 * asmutil.h -- assembly stuff
 */

#ifndef ASMUTIL_H
#define ASMUTIL_H

#include <stdint.h>

/*** io ***/

extern uint8_t inb(uint16_t port);
extern void outb(uint16_t port, uint8_t value);
extern uint16_t inw(uint16_t port);
extern void outw(uint16_t port, uint16_t value);

/*** special functions ***/

extern void halt(void);
extern void nop(void);
extern void panic(void);
#endif /* ASMUTIL_H */
