/*
 * main.c -- entry but now in c
 */

#include <limine.h>
#include <stdint.h>

#include <drv.h>
#include "dpy.h"

__attribute__((used, section(".limine_requests")))
static volatile uint64_t limine_base_revision[3] = {
    0xf9562b2d5c95a6c8,
    0x6a7b384944536bdc,
    3
};

void
kmain(void)
{
	struct limine_framebuffer* fb = getfb();
	if (!fb)
		for (;;) asm volatile ("hlt");

	checkers(fb);
	xyputpx(fb, 10, 10, fromargb(fb, 252, 0, 222, 255));
}

Drv* drv;

