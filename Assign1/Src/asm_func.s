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
@ R5 for-loop counter i
@ R6 flexi reg
@ R7 floor - curr floor pointer
@ R8 section - curr section pointer
@ R9 cars - # of cars at each entry event
@ R10 available - # of available slots
@ R11 flexi reg
@ R12 parking[floor][sect]
@ R13 stack ptr
@ R14 link register
@ ...

@ Offset = ((i * S) + j) *4

@ write your program from here:

.equ SECTION_MAX, 12
// return value from asm back to C program, R0 register is used
asm_func:
	LDR R4, [R3]		// Load value of result[0][0], which is F
	LDR R5, [R3, #4]	// Load value of result[0][1], which is S
	PUSH {R4}			// push F(R4) to the stack
	MUL R4, R4, R5		// Multiply to get # of elements in the array

	PUSH {R5}			// push S(R5) to the stack

	MOV	R5, #0			// R5 serving as loop counter i, init to 0
	MOV R7, #0			// init R7 (floor) to 0
	MOV R8, #0			// init R8 (section) to 0

FIRST_FOR_LOOP:
	CMP R5, #5			// compare i with 5
	BGE FIRST_LOOP_EXIT	// if i>=5, exit loop

	LDR	R9, [R1, R5, LSL #2] // load entry element from R1 address + (i*4) into R7

WHILE_LOOP:
	CMP R9, #0			// compare #cars remaining for that event >0
	BLE WHILE_LOOP_EXIT	// if cars <= 0, branch back to the main for-loop

	POP {R6}			// POP S to R6
	POP {R11}			// POP F to R11
	CMP R7, R11			// compare floors to confirm there are available floors
	PUSH {R11}			// push F back to the stack
	PUSH {R6}			// push S back after F
	BGE WHILE_LOOP_EXIT	// if floors >= 0, branch back to the main for-loop

	// operations to access 2D array
	POP {R12}			// pop stack to get S
	MUL	R11, R7, R12	// R11 = floor * S (i * s)
	ADD R11, R11, R8	// R11 = (floor * s) + j
	LSL R11, R11, #2	// R11 = (floor * s) + j * 4
	ADD R11, R0, R11	// R11 = address of parking[floor][sect]
	PUSH {R12}			// push S back to the stack
	LDR	R12, [R11]		// store value into R12 (replacement for R12 here)
	RSB R10, R12, #SECTION_MAX // store avail (R10) = section_max - parking[floor][sect]

	CMP R10, #0			// compare avail with 0
	BGT AVAIL_POS		// if avail >0, branch to AVAIL_POS
	B FLOOR_FULL		// branch back to floor_full


AVAIL_POS:
	CMP R9, R10			// compare cars and available
	BLE MORE_AVAIL		// if cars <= available,
	@ for the else cond
	LDR R12, =SECTION_MAX // set parking[floor][sect] to section_max
	STR R12, [R11]		// store R12 val (parking[floor][sect]) into parking array
	SUB R9, R9, R10		// cars -= available
	B FLOOR_FULL		// branch to floor_full

FLOOR_FULL:
	ADD R8, R8, #1		// sec++
	POP {R11}			// pop S back to R11
	CMP R8, R11			// compare sect to S
	PUSH {R11}			// push S back to the stack
	B	SECT_NOT_FULL	// if sect < S, sect is not full
	MOV	R8, #0			// set sect = 0
	ADD R7, R7, #1		// increment floor
	B WHILE_LOOP		// branch back to while loop

MORE_AVAIL:
	ADD R12, R12, R9	// parking[floor][sect] += cars;
	STR R12, [R11]		// store R12 val (parking[floor][sect]) into parking array
	MOV R9, #0			// cars = 0

	B WHILE_LOOP		// branch back to while loop

SECT_NOT_FULL:
	B WHILE_LOOP		// revert back to the main while loop

WHILE_LOOP_EXIT:
	ADD R5, R5, #1		// i++
	B FIRST_FOR_LOOP

FIRST_LOOP_EXIT:
	BX LR

// 	PUSH {R14} // saves caller's link register

//	BL SUBROUTINE // call SUBROUTINE. LR(R14) now holds the return address

// 	POP {R14} // restore the original link register

//	BX LR // return from asm_func

//SUBROUTINE:

//	BX LR // return to the caller using the LR
