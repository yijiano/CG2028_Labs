/*
 * blink_plain_C : main.c
 * Gu Jing, ECE, NUS
 * July 2020
 *
 * Configures AHB2 and GPIO registers to make LD2 on B-L475E-IOT01A board blink, using pure C program.
 * No CMSIS or MCU are used.
 */

	// Addresses of AHB2 Registers
	#define RCC_AHB2RSTR	0x4002102C
	#define RCC_AHB2ENR		0x4002104C
	#define RCC_AHB2SMENR	0x4002106C

	// Addresses of GPIO Registers
	#define GPIOB_MODER 	0x48000400
	#define GPIOB_OTYPER	0x48000404
	#define GPIOB_OSPEEDR	0x48000408
	#define GPIOB_PUPDR		0x4800040C
	#define GPIOB_IDR		0x48000410
	#define GPIOB_ODR		0x48000414
	#define GPIOB_BSRR		0x48000418
	#define GPIOB_LCKR		0x4800041C
	#define GPIOB_AFRL		0x48000420
	#define GPIOB_AFRH		0x48000424
	#define GPIOB_BRR		0x48000428
	#define GPIOB_ASCR		0x4800042C

	#define LEDDELAY	200000
	#define LEDPIN  	(1 << 14)

int main(void)
{
	volatile unsigned int i;
	volatile unsigned int *p;	// pointer declaration
	volatile unsigned int *q;	// pointer declaration

	p = (unsigned int *)RCC_AHB2RSTR;
	*p |= (1 << 1);		// set bit[1] to reset AHB2
	*p &= ~(1 << 1);	// change bit[1] back to 0, no effect

	p = (unsigned int *)RCC_AHB2ENR;
	*p |= (1 << 1);		// AHB2 clock enable, compulsory to support peripheral registers read/write

	p = (unsigned int *)GPIOB_MODER;
	*p &= ~((1 << 29) | (1 << 28));	// clear GPIO mode register's bit[29:28]
	*p |= (1 << 28);	// change GPIO mode register's bit[29:28] = 01, general purpose output

	while(1)
	{
		p = (unsigned int *)GPIOB_BSRR;
		q = (unsigned int *)GPIOB_ODR;

		if (*q & LEDPIN)	// read GPIO Output data register to check current state of Pin14
		{
			*p &= ~((1 << 30) | (1 << 14));	// clear GPIO BSRR's bit[30] and bit[14]
			*p |= (1 << 30);	// set BSRR's bit[30], reset bit, to turn LD2 off
		}
		else
			*p |= (1 << 14);	// set BSRR's bit[14], set bit, to turn LD2 on

		for (i = 0; i < 200000; i++);	// delay loop
	}
	return 0;
}
