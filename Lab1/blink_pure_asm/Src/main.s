/*
 * blink_pure_asm : main.s
 * Gu Jing, ECE, NUS
 * July 2020
 *
 * Configures AHB2 and GPIO registers to make LD2 on B-L475E-IOT01A board blink.
 */

	.syntax unified @ make ARM 32-bit instruction set available
	.global main

@ Equates

     @ Addresses of AHB2 Registers
	.equ RCC_AHB2RSTR,	0x4002102C
	.equ RCC_AHB2ENR,	0x4002104C
	.equ RCC_AHB2SMENR,0x4002106C

     @ Addresses of GPIO Registers
	.equ GPIOB_MODER, 	0x48000400
	.equ GPIOB_OTYPER,	0x48000404
	.equ GPIOB_OSPEEDR,	0x48000408
	.equ GPIOB_PUPDR,	0x4800040C
	.equ GPIOB_IDR,		0x48000410
	.equ GPIOB_ODR,		0x48000414
	.equ GPIOB_BSRR,	0x48000418
	.equ GPIOB_LCKR,	0x4800041C
	.equ GPIOB_AFRL,	0x48000420
	.equ GPIOB_AFRH,	0x48000424
	.equ GPIOB_BRR,		0x48000428
	.equ GPIOB_ASCR,	0x4800042C
	.equ LEDDELAY,		200000


@ blink PB14 by purely assembly program
main:
	@ set AHB2 Registers
	@ AHB2 peripheral reset register: RCC_AHB2RSTR
	@ reset value = 0x00000000, bit[1]=1 is to reset port_B
	LDR R6, =RCC_AHB2RSTR
    LDR R0, [R6]
    ORR R0, 0x00000002	@ set bit[1] to 1
    STR R0, [R6]
    AND R0, 0xFFFFFFFD @ clear bit[1] to 0
    STR R0, [R6]

	@ AHB2 peripheral clock enable register: RCC_AHB2ENR
	@ reset value = 0x00000000, bit[1]=1 is to enable port B's clock
	LDR R6, =RCC_AHB2ENR
    LDR R0, [R6]
    ORR R0, 0x00000002	@ set bit[1] to 1
    STR R0, [R6]

	@ AHB2 peripheral clocks enable in sleep and stop modes register: RCC_AHB2SMENR
	@ reset value = 0x000532FF
	LDR R6, =RCC_AHB2SMENR
    LDR R0, [R6]	@ to verify RCC_AHB2SMENR's reset value

	@ set mode as general purpose output mode to Port_B Pin_14
    LDR R6, =GPIOB_MODER
    LDR R0, [R6]
    AND R0, 0xCFFFFFFF
    ORR R0, 0x10000000
    STR R0, [R6]

    @ Output type is output push-pull (Default value)
    @ Output speed is low (Default value)
    @ Pull-up/pull-down mode is no pull-up/down (Default value)

BLINK:
	@ turn on PB14 using BSRR bit[14]
	LDR R6, =GPIOB_BSRR
    LDR R0, [R6]
    ORR R0, 0x00004000
    STR R0, [R6]
    LDR R1, =LEDDELAY

ON_DELAY:
	SUBS R1, #1
	BNE ON_DELAY

	@ turn off PB14 using BSRR bit[30]
	LDR R6, =GPIOB_BSRR
    LDR R0, [R6]
    AND R0, 0xBFFFBFFF
    ORR R0, 0x40000000
    STR R0, [R6]
    LDR R1, =LEDDELAY

OFF_DELAY:
	SUBS R1, #1
	BNE OFF_DELAY

	B BLINK

HALT:
	B HALT
