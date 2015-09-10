#include "uart.h"
#include "led.h"



int main()
{
	char c;
	GPIO_LedInit();
	
	
	init_uart();
	while(1)
	{
		LedTest();
		c = getchar();
		putchar(c+1);	
	}

	return 0;
}

