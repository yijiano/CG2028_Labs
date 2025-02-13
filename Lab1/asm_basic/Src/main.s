/*
 * asm_basic : main.s
 * Gu Jing, ECE, NUS
 * July 2020
 *
 * Simple ARM assembly file to demonstrate basic asm instructions.
 */

	.syntax unified
	.global main

@ Equates, equivalent to #define in C program
	.equ C,	20
	.equ D,	400

main:
@ Code starts here
@ Calculate ANSWER = A*B + C*D

	LDR R0, A
	LDR R1, B
	MUL R0, R0, R1
	LDR R1, =C
	LDR R2, =D
	MLA R0, R1, R2, R0
	MOV R4, R0
	LDR R3, =ANSWER
	STR R4, [R3]

HALT:
	B HALT

@ Define constant values
A:	.word	100
B:	.word	50

@ Store result in SRAM (4 bytes)
.lcomm	ANSWER	4
.end
