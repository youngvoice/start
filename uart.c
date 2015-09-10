

#include"uart.h"

void init_uart(void)
{
	GPACON &= ~0xff;
	GPACON |= 0x22;
	
	/* ULCON0 */
	ULCON0 = 0x3;  /* ����λ:8, �޽���, ֹͣλ: 1, 8n1 */
	UCON0  = 0x5;  /* ʹ��UART���͡����� */
	UFCON0 = 0x01; /* FIFO ENABLE */

	UMCON0 = 0; /*CTS signal is not activated*/
	
	/* ������ */
	/* DIV_VAL = (PCLK / (bps x 16 ) ) - 1 
	 * bps = 115200
	 * DIV_VAL = (66500000 / (115200 x 16 ) ) - 1 
	 *         = 35.08
	 */
	UBRDIV0   = 35;

	/* x/16 = 0.08
	 * x = 1
	 */
	UDIVSLOT0 = 0x1;
	
}

char getchar(void)
{
	while ((UFSTAT0 & 0x7f) == 0);  /* ���RX FIFO�գ��ȴ� */
	return URXH0;                   /* ȡ���� */
}

void putchar(char c)
{
	while (UFSTAT0 & (1<<14)); /* ���TX FIFO�����ȴ� */
	UTXH0 = c;                         /* д���� */
}


