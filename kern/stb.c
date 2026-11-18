/*
 * stb.c -- implement the stb libraries
 */

#include <stddef.h>

// Freestanding replacement for qsort().
static void stb_rect_sort(
    void *base,
    size_t count,
    size_t size,
    int (*compare)(const void *, const void *)
) {
    unsigned char *array = base;

    // Insertion sort: sufficient for a small font atlas.
    for (size_t i = 1; i < count; i++) {
        size_t j = i;

        while (j > 0 &&
               compare(array + (j - 1) * size,
                       array + j * size) > 0) {

            // Swap the two elements.
            for (size_t k = 0; k < size; k++) {
                unsigned char tmp = array[(j - 1) * size + k];

                array[(j - 1) * size + k] =
                    array[j * size + k];

                array[j * size + k] = tmp;
            }

            j--;
        }
    }
}

#define STBRP_SORT stb_rect_sort
#define STBRP_ASSERT(x) ((void)0)

#define STB_RECT_PACK_IMPLEMENTATION
#include "stb/rect_pack.h"

#define STB_SPRINTF_IMPLEMENTATION
#include "stb/sprintf.h"

