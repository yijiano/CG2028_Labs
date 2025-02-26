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

@ R0 ptr to first element in 2D array for building slots / entry event index j / exit event index l
@ R1 ptr to array for entry events
@ R2 ptr to array for exit events
@ R3 ptr 2D array for results
@ R4 # of elements (F*S)
@ R5 copy loop index i / section index k
@ R6 flexi-register
@ R8 # of cars in entry[section] during EXIT_FOR_LOOP
@ R9 current section capacity / remaining cars during exit event
@ R13 stack pointer (SP)
@ R14 link register (LR)
@ ...

@ Offset = ((i * S) + j) *4

@ write your program from here:

.equ SECTION_MAX, 12
@ return value from asm back to C program, R0 register is used
asm_func:
	PUSH {LR}

	@ Calculate F*S
	LDR R4, [R3]					@ Load value of result[0][0], which is F
	LDR R5, [R3, #4]				@ Load value of result[0][1], which is S
	MUL R4, R4, R5					@ Multiply to get # of elements in the array (F*S)
	MOV	R5, #0						@ R5 serving as copy loop counter i, init to 0

@ Copy the building array to results array (initial state of building)
COPY_LOOP:
	CMP R5, R4
    BGE COPY_LOOP_DONE
    LDR R6, [R0, R5, LSL #2]   		@ load building[i] using building pointer in R0
    STR R6, [R3, R5, LSL #2]   		@ store it to result[i]
    ADD R5, R5, #1
    B COPY_LOOP

COPY_LOOP_DONE:
    MOV R0, #0              		@ repurpose R0 to entry event index (0 to 4)
    MOV R5, #0              		@ repurpose R5 to section index (for result array)

@ Process each entry index
ENTRY_FOR_LOOP:
	CMP R0, #5						@ compare j with 5
	BGE ENTRY_FOR_LOOP_DONE			@ if i>=5, exit loop

	LDR	R8, [R1, R0, LSL #2] 		@ cars = entry[j]

@ Check each section to accomodate new cars from current entry index
ENTRY_WHILE_LOOP:
	@ check (cars && j < F*S) condition
	CMP R8, #0
	BEQ ENTRY_WHILE_LOOP_DONE		@ if cars == 0 then exit
	CMP R5, R4
	BGE ENTRY_WHILE_LOOP_DONE		@ if k >= F*S then exit

	LDR R6, [R3, R5, LSL #2]		@ load result[k]
	MOV R9, #SECTION_MAX			@ load SECTION_MAX
	SUB R9, R9, R6					@ current section capacity = SECTION_MAX - result[k]

	@ Current section is full; move to next
	CMP R9, #0 						@ current section capacity <= 0
	BLE NEXT_SECTION

	@ All incoming cars fit in the current section
	CMP R8, R9 						@ cars <= current section capacity
	BLE FILL_SECTION

	@ Fill the current section completely and move to the next
	SUB R8, R8, R9					@ cars -= (SECTION_MAX - result[k])
	MOV R6, #SECTION_MAX
	STR R6, [R3, R5, LSL #2]		@ result[k] = SECTION_MAX;

NEXT_SECTION:
	ADD R5, R5, #1					@ k++
	B ENTRY_WHILE_LOOP				@ next iteration of while loop

FILL_SECTION:
	ADD R6, R6, R8
	STR R6, [R3, R5, LSL #2]		@ result[k] += cars
	MOV R8, #0						@ cars = 0
	B ENTRY_WHILE_LOOP				@ next iteration of while loop

ENTRY_WHILE_LOOP_DONE:
	ADD R0, R0, #1					@ j++
	B ENTRY_FOR_LOOP				@ next entry event

ENTRY_FOR_LOOP_DONE:
	MOV R0, #0

EXIT_FOR_LOOP:
	CMP R0, R4						@ compare l with F*S
	BGE EXIT_FOR_LOOP_DONE			@ exit if l >= F*S

	LDR     R9, [R3, R0, LSL #2]   	@ load current result[l]
    LDR     R6, [R2, R0, LSL #2]   	@ load exit[l]
    SUB     R9, R9, R6           	@ compute remaining = result - exit

    CMP     R9, #0
    BGE     EXIT_STORE_BRANCH		@ if remaining >= 0, store result
    MOV     R9, #0               	@ if negative, set to 0

EXIT_STORE_BRANCH:
    STR     R9, [R3, R0, LSL #2]   	@ store updated result
    ADD     R0, R0, #1
    B       EXIT_FOR_LOOP

EXIT_FOR_LOOP_DONE:
	POP {LR}
	BX LR
