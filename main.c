#define rGPMCON		(*(volatile unsigned *)(0x7F008820))
#define rGPMDAT		(*(volatile unsigned *)(0x7F008824))
#define rGPMPUD		(*(volatile unsigned *)(0x7F008828))

void msDelay(int time)
{
	volatile unsigned int i,j;
	for (i=0;i<20000;i++)
		for(j=0;j<time;j++);	
}

void GPIO_Init(void)
{
	rGPMCON = 0x11111;
	rGPMPUD = 0x00;
	rGPMDAT = 0x1F;	
}

void LedTest(void)
{
	volatile unsigned int i;
	while(1)
	{
		for(i=0;i<4;i++)
		{
			rGPMDAT =~(1<<i);
			msDelay(10);	
		}	
	}	
}
int main()
{
	GPIO_Init();
	LedTest();

	return 0;
}

