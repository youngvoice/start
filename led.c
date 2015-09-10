#include "led.h"

void msDelay(int time)
{
	volatile unsigned int i,j;
	for (i=0;i<20000;i++)
		for(j=0;j<time;j++);	
}

void GPIO_LedInit(void)
{
	rGPMCON = 0x11111;
	rGPMPUD = 0x00;
	rGPMDAT = 0x1F;	
}

void LedTest(void)
{
	volatile unsigned int i;
	
	
		for(i=0;i<4;i++)
		{
			rGPMDAT =~(1<<i);
			msDelay(10);	
		}	
		
}
