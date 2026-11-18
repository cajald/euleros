/*
 * dpy.h -- display driver
 */

#ifndef ARG_DPY_H
#define ARG_DPY_H

#include <stdint.h>
#include <drv.h>

#define DRV_DPY 0xfdfb

struct dpy_resv {
    void *ctx;

    void (*xyputpx)(void *fb,
                    uint64_t x, uint64_t y,
                    uint32_t col);

    uint32_t (*fromargb)(void *fb,
                         uint8_t r, uint8_t g,
                         uint8_t b, uint8_t a);

    void (*putargb)(void *fb,
                    uint64_t x, uint64_t y,
                    uint8_t r, uint8_t g,
                    uint8_t b, uint8_t a);
};

/* Framebuffer functions */

void *getfb(void);

void checkers(void *fb);

void blendpx(void *fb, uint64_t x, uint64_t y,
             uint8_t r, uint8_t g,
             uint8_t b, uint8_t a);

uint32_t packchan(uint8_t value,
                  uint8_t mask_size,
                  uint8_t mask_shift);

uint32_t fromargb(void *fb,
                  uint8_t r, uint8_t g,
                  uint8_t b, uint8_t a);

void xyputpx(void *fb, uint64_t x, uint64_t y,
             uint32_t col);

#endif /* ARG_DPY_H */

