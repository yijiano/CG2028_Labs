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
@ R9 SECTION_MAX
@ R11 general counter
@ R13 stack pointer (SP)
@ R14 link register (LR)
@ ...

@ Offset = ((i * S) + j) *4

@ write your program from here:

.equ SECTION_MAX, 12
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
	PUSH {LR}
	LDR R6, [R3]					@ Load F, which is first index of result array
	LDR R8, [R3, #4]				@ Load S, which is second index of result array
	MUL R4, R6, R8					@ Multiply to get # of elements in the array (F*S)

	MOV R11, #0              		@ Init R11 to entry event index (0 to 4)
	MOV R5, #0              		@ Init # of cars to be added to carpark = 0

SUM_ENTRY_CARS_FOR_LOOP:
	CMP R11, #5
	BGE BEFORE_PROCESS_BUILDING		@ If entry event index >= 5, exit this for loop

	LDR	R6, [R1, R11, LSL #2]		@ Load entry[i]
	ADD R5, R5, R6					@ # of cars to be added to carpark += entry[i]
	ADD R11, R11, #1				@ i++
	B SUM_ENTRY_CARS_FOR_LOOP

BEFORE_PROCESS_BUILDING:
	MOV R11, #0              		@ Repurpose R11 to building section index (0 to F*S-1)

PROCESS_BUILDING_LOOP:
	CMP R11, R4
	BGE EXIT_ASM_FUNC 				@ If section index >= F*S, exit this for loop

	LDR R6, [R0, R11, LSL #2]		@ Load building[i]
	MOV R9, SECTION_MAX
	SUB R8, R9, R6					@ Calculate # of free lots (SECTION_MAX - building[i])

	CMP R5, #0
	BLE PROCESS_EXIT_EVENTS			@ if there are no cars left to be added, skip the adding routine

	@ Add Car Routine
	CMP R8, R5
	ITE GE
	ADDGE R6, R6, R5				@ Section capacity >= cars, add remaining cars to be parked into current section
	MOVLT R6, R9					@ Section capacity < cars, fill all lots in current section

PROCESS_EXIT_EVENTS:
	SUB R5, R5, R8					@ Subtract cars parked. For last section, the result will be <= 0
	LDR R8, [R2, R11, LSL #2]		@ load exit[i]
	SUB R6, R6, R8					@ Calc cars left after exit event
	STR R6, [R3, R11, LSL #2]		@ Store result[i]

	ADD R11, R11 ,#1				@ i++
	B PROCESS_BUILDING_LOOP

EXIT_ASM_FUNC:
	POP {LR}
	BX LR
