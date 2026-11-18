/*
 * fb.c -- get framebuffer
 * 
 * Limine lets us request a framebuffer, this code is used for
 *   - acquiring the framebuffer
 *   - putting a pixel
 */

#include <limine.h>

#include "dpy.h"

#define NULL (void*)(0)
#define TILE_SIZE 16

__attribute__((used, section(".limine_requests")))
static volatile struct limine_framebuffer_request framebuffer_request =
{
	.id = LIMINE_FRAMEBUFFER_REQUEST_ID,
	.revision = 0
};

/** Acquires a framebuffer */
void*
getfb(void)
{
	if (framebuffer_request.response == NULL)
		return NULL;
	if (framebuffer_request.response->framebuffer_count == 0)
		return NULL;

	return (void*)framebuffer_request.response->framebuffers[0];
}

/** Display a checkers background */
void
checkers(void* fbp)
{
	struct limine_framebuffer* fb = fbp;
	if (!fb || fb->bpp != 32)
		return;

	for (uint64_t y = 0; y < fb->height; y++) {
		for (uint64_t x = 0; x < fb->width; x++) {
			uint32_t color;

			if (((x / TILE_SIZE) + (y / TILE_SIZE)) % 2 == 0)
				color = 0xFFFFFFFF; /* white */
			else
				color = 0x00000000; /* black */

			uint32_t *pixel = (uint32_t *)(
				(uint8_t *)fb->address +
				y * fb->pitch +
				x * 4
			);

			*pixel = color;
		}
	}
}

void
blendpx(void *ptr, uint64_t x, uint64_t y,
	uint8_t r, uint8_t g, uint8_t b, uint8_t a)
{
	struct limine_framebuffer* fb = ptr;

	if (!fb || x >= fb->width || y >= fb->height)
		return;

	if (fb->bpp != 32)
		return;

	uint32_t* pixel = (uint32_t *)(
			(uint8_t *)fb->address +
			y * fb->pitch + x * 4
			);

	uint32_t old = *pixel;

	uint8_t dr = (old >> fb->red_mask_shift) &
		((1u << fb->red_mask_size) - 1);

	uint8_t dg = (old >> fb->green_mask_shift) &
		((1u << fb->green_mask_size) - 1);

	uint8_t db = (old >> fb->blue_mask_shift) &
		((1u << fb->blue_mask_size) - 1);

	/* scale destination channels to 0-255 */
	dr = dr * 255 / ((1u << fb->red_mask_size) - 1);
	dg = dg * 255 / ((1u << fb->green_mask_size) - 1);
	db = db * 255 / ((1u << fb->blue_mask_size) - 1);

	/* alpha blend. */
	uint8_t nr = (r * a + dr * (255 - a)) / 255;
	uint8_t ng = (g * a + dg * (255 - a)) / 255;
	uint8_t nb = (b * a + db * (255 - a)) / 255;

	*pixel = fromargb(fb, nr, ng, nb, 255);
}

uint32_t
packchan(uint8_t value,
	 uint8_t mask_size,
	 uint8_t mask_shift)
{
	if (!mask_size)
		return 0;

	uint32_t max = (1u << mask_size) - 1;

	return (((uint32_t)value * max + 127) / 255)
		<< mask_shift;
}

uint32_t
fromargb(void *fbp,
	 uint8_t r, uint8_t g,
	 uint8_t b, uint8_t a)
{
	struct limine_framebuffer* fb = fbp;

	if (!fb)
		return 0;

	(void)a;

	return packchan(r, fb->red_mask_size,
			fb->red_mask_shift)
		| packchan(g, fb->green_mask_size,
			fb->green_mask_shift)
		| packchan(b, fb->blue_mask_size,
			fb->blue_mask_shift);
}

void
xyputpx(void *fbp, uint64_t x, uint64_t y,
	uint32_t color)
{
	struct limine_framebuffer* fb = fbp;

	if (!fb || x >= fb->width || y >= fb->height)
		return;

	if (fb->bpp != 32)
		return;

	uint32_t *pixel = (uint32_t*)(
			(uint8_t*) fb->address +
			y * fb->pitch + x * 4
		);

	*pixel = color;
}

