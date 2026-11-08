/*
 * main.c -- entry but now in c
 */

#include <stdint.h>

__attribute__((used, section(".limine_requests")))
static volatile uint64_t limine_base_revision[3] = {
    0xf9562b2d5c95a6c8,
    0x6a7b384944536bdc,
    3
};

void
kmain(void)
{
}

