
/**
 ******************************************************************************
 * @project        : CG/[T]EE2028 Assignment 1 Program Template
 * @file           : main.c
 * @author         : Hou Linxin, ECE, NUS
 * @brief          : Main program body
 ******************************************************************************
 *
 * @attention
 *
 * <h2><center>&copy; Copyright (c) 2019 STMicroelectronics.
 * All rights reserved.</center></h2>
 *
 * This software component is licensed by ST under BSD 3-Clause license,
 * the "License"; You may not use this file except in compliance with the
 * License. You may obtain a copy of the License at:
 *                        opensource.org/licenses/BSD-3-Clause
 *
 ******************************************************************************
 */
#include "stdio.h"

#define F 3
#define S 2

extern void asm_func(int* arg1, int* arg2, int* arg3, int* arg4);
extern void initialise_monitor_handles(void);

//****************************************************************************

volatile unsigned int *DWT_CYCCNT   = (volatile unsigned int *)0xE0001004;
volatile unsigned int *DWT_CONTROL  = (volatile unsigned int *)0xE0001000;
volatile unsigned int *DWT_LAR      = (volatile unsigned int *)0xE0001FB0;
volatile unsigned int *SCB_DHCSR    = (volatile unsigned int *)0xE000EDF0;
volatile unsigned int *SCB_DEMCR    = (volatile unsigned int *)0xE000EDFC;
volatile unsigned int *ITM_TER      = (volatile unsigned int *)0xE0000E00;
volatile unsigned int *ITM_TCR      = (volatile unsigned int *)0xE0000E80;

void initialise_timer()
{
	*SCB_DEMCR |= 0x01000000;
	*DWT_LAR = 0xC5ACCE55; // enable access
	*DWT_CYCCNT = 0; // reset the counter
	*DWT_CONTROL |= 1 ; // enable the counter
}



int main(void)
{
	initialise_timer();
	initialise_monitor_handles();

	int i,j;


	int building[F][S] = {{8,8},{8,8},{8,8}};
	int entry[5] =  {1,2,3,4,5};
	int exit[F][S] = {{1,2},{2,3},{3,4}};
	int result[F][S] = {{F,S},{0,0},{0,0}};

	int start_time = *DWT_CYCCNT;
	asm_func((int*)building, (int*)entry, (int*)exit, (int*)result);
	int end_time = *DWT_CYCCNT;

	printf("TEST CASE 1\n");
	for (i=0; i<F; i++)
	{
		for (j=0; j<S; j++)
		{
			building[i][j] = result[i][j];
			printf("%d\t", building[i][j]);
		}
	printf("\n");
	}

	// Prints final cycles taken, the overhead is 8 clock cycles
	printf("No. of Clock Cycles Taken: %d\n", end_time - start_time);
	printf("End \n");

//	int building[F][S] = {{1,2},{3,4},{5,6}};
//	int entry[5] =  {1,1,1,1,1};
//	int exit[F][S] = {{1,0},{0,0},{0,0}};
//	int result[F][S] = {{F,S},{0,0},{0,0}};
//
//	asm_func((int*)building, (int*)entry, (int*)exit, (int*)result);
//
//	printf("TEST CASE 2\n");
//	for (i=0; i<F; i++)
//	{
//		for (j=0; j<S; j++)
//		{
//			building[i][j] = result[i][j];
//			printf("%d\t", building[i][j]);
//		}
//	printf("\n");
//	}

//	int building[F][S] = {{12,12},{10,5},{3,7}};
//	int entry[5] =  {1,1,1,1,5};
//	int exit[F][S] = {{1,2},{3,4},{3,6}};
//	int result[F][S] = {{F,S},{0,0},{0,0}};
//
//	asm_func((int*)building, (int*)entry, (int*)exit, (int*)result);
//
//	printf("TEST CASE 3\n");
//	for (i=0; i<F; i++)
//	{
//		for (j=0; j<S; j++)
//		{
//			building[i][j] = result[i][j];
//			printf("%d\t", building[i][j]);
//		}
//	printf("\n");
//	}
//
//	int building[F][S] = {{12,12},{12,12},{12,12}};
//	int entry[5] =  {0,0,0,0,0};
//	int exit[F][S] = {{2,2},{3,3},{4,4}};
//	int result[F][S] = {{F,S},{0,0},{0,0}};
//
//	asm_func((int*)building, (int*)entry, (int*)exit, (int*)result);
//
//	printf("TEST CASE 4\n");
//	for (i=0; i<F; i++)
//	{
//		for (j=0; j<S; j++)
//		{
//			building[i][j] = result[i][j];
//			printf("%d\t", building[i][j]);
//		}
//	printf("\n");
//	}
//
//	int building[F][S] = {{9,10},{7,8},{4,4}};
//	int entry[5] =  {2,4,6,8,10};
//	int exit[F][S] = {{1,1},{1,1},{1,1}};
//	int result[F][S] = {{F,S},{0,0},{0,0}};
//
//	asm_func((int*)building, (int*)entry, (int*)exit, (int*)result);
//
//	printf("TEST CASE 5\n");
//	for (i=0; i<F; i++)
//	{
//		for (j=0; j<S; j++)
//		{
//			building[i][j] = result[i][j];
//			printf("%d\t", building[i][j]);
//		}
//	printf("\n");
//	}
//
//	int building[F+1][S+1] = {{8,8,8},{8,8,8},{8,8,8},{8,8,8}};
//	int entry[5] =  {1,2,3,4,5};
//	int exit[F+1][S+1] = {{1,2,3},{1,2,3},{1,2,3},{1,2,3}};
//	int result[F+1][S+1] = {{F+1,S+1,0},{0,0,0},{0,0,0},{0,0,0}};
//
//	asm_func((int*)building, (int*)entry, (int*)exit, (int*)result);
//
//	printf("TEST CASE 6?\n");
//	for (i=0; i<F+1; i++)
//	{
//		for (j=0; j<S+1; j++)
//		{
//			building[i][j] = result[i][j];
//			printf("%d\t", building[i][j]);
//		}
//	printf("\n");
//	}
}
