#ifndef _LED_H_
#define _LED_H_

#define rGPMCON		(*(volatile unsigned *)(0x7F008820))
#define rGPMDAT		(*(volatile unsigned *)(0x7F008824))
#define rGPMPUD		(*(volatile unsigned *)(0x7F008828))

extern void GPIO_LedInit(void);
extern void LedTest(void);
#endif
