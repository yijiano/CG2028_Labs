/*
 * asm_func.s
 *
 *  Created on: 7/2/2025
 *      Author: Hou Linxin
 */
   .syntax unified
	.cpu cortex-m4
	.fpu softvfp
	.thumb

		.global asm_func

@ Start of executable code
.section .text

@ CG/[T]EE2028 Assignment 1, Sem 2, AY 2024/25
@ (c) ECE NUS, 2025

@ Write Student 1’s Name here: Zhang Yijian
@ Write Student 2’s Name here: Leong Deng Jun

@ Look-up table for registers:

@ R0 ptr to first element in 2D array for building slots
@ R1 ptr to array for entry events
@ R2 ptr to array for exit events
@ R3 ptr 2D array for results
@ R4 # of elements (F*S)
@ R5 # of cars to be added to carpark
@ R6 flexi-register
@ R8 flexi-register
@ R9 flexi-register
@ R11 general counter
@ R13 stack pointer (SP)
@ R14 link register (LR)
@ ...

@ Offset = ((i * S) + j) *4

@ write your program from here:

.equ SECTION_MAX, 12
.equ NUM_ENTRY_EVENTS, 5
@ return value from asm back to C program, R0 register is used

/*
	Overview:
	1. Calculate F * S
	2. Sum the total # of cars to be parked
	3. Iterate through building array (one pass):
		3a. Fill cars in current section based on total # of cars to be parked
		3b. Before moving to next iteration, subtract the number of cars to exit
	4. Return
*/

asm_func:
	LDR R6, [R3]					@ Load F, which is first index of result array
	LDR R8, [R3, #4]				@ Load S, which is second index of result array
	MUL R4, R6, R8					@ Multiply to get # of elements in the array (F*S)

	MOV R5, #0						@ Init # of cars to be added to carpark = 0
	MOV R11, #NUM_ENTRY_EVENTS		@ Init # of entry events

SUM_ENTRY_CARS_FOR_LOOP:
	LDR	R6, [R1], #4				@ Load entry[i], then incremenet address using post-index
	ADD R5, R5, R6					@ # of cars to be added to carpark += entry[i]
	SUBS R11, R11, #1				@ Decrement entry event count
	BNE SUM_ENTRY_CARS_FOR_LOOP		@ remaining entry events >= 0, go to nex iterations

PROCESS_BUILDING_LOOP:
	LDR R6, [R0], #4				@ Load building[i], then incremenet address using post-index
	RSB R8, R6, #SECTION_MAX		@ Calculate # of free lots (SECTION_MAX - building[i])
	CMP R5, #0
	BLE PROCESS_EXIT_EVENTS			@ if there are no cars left to be added, skip the adding routine

	@ Add Car Routine
	CMP R8, R5
	ITE GE
	ADDGE R6, R6, R5				@ Section capacity >= cars, add remaining cars to be parked into current section
	MOVLT R6, #SECTION_MAX			@ Section capacity < cars, fill all lots in current section

PROCESS_EXIT_EVENTS:
	SUB R5, R5, R8					@ Subtract cars parked. For last section, the result will be <= 0
	LDR R8, [R2], #4				@ Load exit[i], then incremenet address using post-index
	SUB R6, R6, R8					@ Calc cars left after exit event
	STR R6, [R3], #4				@ Store result[i], then incremenet address using post-index

	SUBS R4, R4, #1					@ F*S - 1
	BNE PROCESS_BUILDING_LOOP		@ if F*S >= 0, go to nex iterations

EXIT_ASM_FUNC:
	BX LR
