/*
 * drv.h -- driver
 *
 * This defines the basic structure for a driver
 */

#ifndef ARG_DRV_H
#define ARG_DRV_H

typedef struct drv Drv;

struct drv
{
	unsigned type;
	void (*init)(void);
	void (*deinit)(void);

	/*
	 * used by the different kinds of drivers
	 * to add functions
	 */
	void* resv;
};

typedef Drv* (*MakeDrvFn);

/* loaded drivers */
extern Drv* loddrvs;

void regdrv(Drv* drv, MakeDrvFn mdfn);
void unregdrv(Drv* drv);

#endif /* ARG_DRV_H */
