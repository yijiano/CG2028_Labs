# CG2028 Assignment AY2425S2
1. Background Concepts

![image](https://github.com/user-attachments/assets/65ddf93e-c6bd-4ba1-b3fc-97d0917aba56)

A smart parking system is implemented in a multi-story car park. The car park has F floors and S parking sections on each floor. The system tracks the cars parked in the parking sections in real-time. At the start of each day, the system records the number of cars parked on each floor. Throughout the day, cars enter the car park from time to time. The cars only exit the car park at the end of a day. The objective of this assignment is to develop a system that updates the cars parked at the end of the day, considering the initial state, cars entering, and cars exiting.

![image](https://github.com/user-attachments/assets/e8399ba7-d2fb-4582-9ba7-b8d576154773)

Figure 1 demonstrates an example with a car park having 3 floors and 2 parking sections per floor. The initial state of the car park is represented by a 2D array {{8, 8}, {8, 8}, {8, 8}}, where each element represents the number of cars parked in a section. The number of cars entering the car park throughout the day is given as a 1D array {1, 2, 3, 4, 5} representing the number of cars entering at different times of the day. The number of cars exiting in each section at the end of the day is represented by {{1, 2}, {2, 3}, {3, 4}}.

To update the cars parked, two rules need to be followed:

(1) The maximum number of cars that can park in each section is 12.

(2) Cars entering the car park are assigned to sections floor by floor, starting from the first section on the first floor (building[0][0]). When a section reaches its maximum capacity of 12, incoming cars are directed to the next section on the same floor.

Therefore, with the given numbers for this example and SECTION_MAX = 12, the expected number of cars parked at the end of the day will be {{11, 10}, {10, 8}, {5, 4}}.

2. Objective
The objective of this assignment is to develop an ARMv7-M assembly language function asm_fun() that updates the cars parked in each section at the end of the day, considering the initial state, cars entering, and cars exiting.

3. Getting Started
Import the Assign1.zip Download Assign1.ziparchive file which contains the "Assign1" project. Within the src folder of this project, there are 2 files you need to pay attention to:

asm_func.s: which is where you will write the assembly language function.
main.c: which is a C program that calls your assembly function.
The C program main.c defines a 2D array "building" representing the initial state of the car park, and a 2D array "exit" representing the number of cars exiting each section at the end of the day. It also defines a 1D array "entry" representing the number of cars entering the car park at different times.

The elements of the "building" array are stored row by row in consecutive words in memory. The "exit" and "entry" arrays are stored similarly.

The C program calls the function asm_fun() which you will write in assembly language. This function computes the final cars parked and stores it in the "result" array.

Question 1: Knowing the starting address of array Building[][], how to calculate the memory address of element building[A][B] with floor index A and section index B, with the index starting from 0? Use drawing or equation to explain your answer. (4 marks)

The function definition for asm_func() in main.c is extern void asm_func(int* arg1, int* arg2, int* arg3, int* arg4), which accepts four parameters:

building[][] (Initial state of the car park)
exit[][] (Number of cars exiting each section)
entry[] (Number of cars entering the car park. You can assume the size of this array is always 5.)
result[][] (Array to store the final cars parked, also containing F, S)
4. Parameter passing between C program and assembly language function
In general, parameters can be passed between a C program and an assembly language function through the ARM Cortex-M4 registers. In the function extern int asm_func (arg1, arg2, ….):

arg1 will be passed to the assembly language function asm_func() in the R0 register, arg2 will be passed in the R1 register, and so on. Totally 4 parameters can be passed from C program to assembly program in this way. To return value from an assembly language function back to C program, R0 register is used.

The final cars parked in the building should be stored in the result[ ][ ] array so that they can be used to replace the old building[ ][ ] array and print out in C program.

In the asm_func.s, there is a subroutine called SUBROUTINE declared after the main part of assembly program, in order to demonstrate the way to “create and call a function” in an assembly language program. Note: The purpose of this declaration is to lead to the thinking of link register (LR/R14). At the completion of this assignment, SUBROUTINE is not compulsory to be used, i.e. you may not have BL SUBROUTINE in your function asm_fun().

5. PUSH and POP
(i) Comment the PUSH {R14} and POP {R14} lines in asm_fun.s, compile the “Assign1” project and execute the program.

(ii) Uncomment the PUSH {R14} and POP {R14} lines in asm_fun.s recompile and execute the program again.

Question 2: Describe what you observe in (i) and (ii) and explain why there is a difference. (4 marks)

6. Programming Tips
Write the code for the assembly language function asm_func() to fulfill the objective mentioned in Section 2 after reading the following aspects carefully.

• It is a good practice to push the contents in the affected general purpose registers onto the stack prior to or upon entry into the assembly language function or subroutine, and to pop those values at the end of the assembly language function or subroutine to recover them.

• If you are using a subroutine, special care must be taken with the Link Register (R14). If the content of this register is lost, the program will not be able to return correctly from the subroutine to the calling part of the program.

• If a set of actions are conditional, you may use the ARM assembly language IF-THEN (IT) block feature or conditional branch.

• In a RISC processor such as the ARM, arithmetic and logical operations only operate on values in registers. However, there are only a limited number of general purpose registers, and programs, e.g. complex mathematical functions, may have many terms.

Hint: Use and re-use the registers in a systematic way. Maintain a data dictionary or table to help you keep track of the storage of different terms in different registers at different times.

Question 3: What can you do if you have used up all the general purpose registers and you need to store some more values during processing? (2 marks)

Note: Each team member should make both joint and specific individual contributions towards the results of this assignment. Verify the correctness of the results computed by the asm_func() function you have written by comparing what appears at the console window of the STM32CubeIDE with the desired output shown below:

F=0,S=0

11

F=0,S=1

10

F=1,S=0

10

F=1, S=1

8

F=2,S=0

5

F=2,S=1

4

In the template program, since the displays are achieved by a nested for-loop which starts from index[0][0], you should see the following sequence and order in the console window:

![image](https://github.com/user-attachments/assets/918cab07-2059-467c-9c06-e674c5cd7bc8)


7. Machine Code and Microarchitecture
After finishing writing your code, you will also need to write down the machine code corresponding to 5 assembly language instructions in your code. You will select the lines of instructions by yourself. You need to select at least 1 data processing instruction, 1 memory accessing instruction, and 1 branching instruction.

Note the following:

You can assume that the instruction memory starts at a location 0x00000000.
Follow the encoding format given in Lecture 4. The actual ARMv7M encoding format is different, but we will be sticking to the encoding format given in Lecture 4 for simplicity.
Only the machine codes for the following instructions should be selected.
Data processing instructions such as ADD, SUB, MOV$, MUL, MLA, AND, ORR, CMP, etc., if they are used without shifts (i.e., the Operand2 is either a register without shift or imm8).
Load and Store instructions in offset, PC-relative, pre-indexed and post-indexed modes.
Branch instructions - conditional and unconditional, i.e., of the form B{cond} LABEL.
$MOV is also one of the 16 DP instructions with the cmd 0b1101 as mentioned in slide 37 of Chapter 4. For MOV instruction, Rn is not used. You can encode Rn (Instr19:16) = 0b0000. This makes sense as MOV has only one source operand which can be a register or immediate (recall: the assembly language format for MOV is MOV Rd, Rm or MOV Rd, #imm8), which means it can only come from the second source operand. Hence, the first source operand (which has to be a register, not immediate) is not used.

You do not need to provide machine codes for instructions which do not fall into the categories above, even if you have used them in your program (e.g., BX, MOVW, multiplication instructions with 64-bit products such as UMULL/SMULL/UMLAL/SMLAL/SDIV/UDIV, division, data processing instructions where Operand2 is a register with shift etc.).
Assume all instructions are 32 bits long, and that the assembler places the instructions and data (constants declared using .word) in successive word locations in the same order as they appear in assembly language. This should help compute the offset for PC-relative instructions, branches etc. Note that PC-relative mode is nothing but offset mode (PW=0b10) with Rn=R15.
You will also need to provide a design showing how the microarchitecture (datapath and control unit) covered in Lecture 4 can be modified to support MLA and MUL instructions. You can assume that a hardware multiplier block is available, which takes in two 32-bit inputs Mult_In_A and Mult_In_B, and provides a 32-bit output, Mult_Out_Product combinationally (i.e., without waiting for a clock edge). You can directly edit the microarchitecture from Lecture 4, Page 28 by taking a screenshot.

8. Test Cases
A total of 8 test cases will be tested on your code, including 5 open test cases and 3 hidden test cases. The open test cases are shown below:

Test case 1

int building[F][S] = {{8,8},{8,8},{8,8}};

int entry[5] = {1,2,3,4,5};

int exit[F][S] = {{1,2},{2,3},{3,4}};

Test case 2

int building[F][S] = {{1,2},{3,4},{5,6}};

int entry[5] = {1,1,1,1,1};

int exit[F][S] = {{1,0},{0,0},{0,0}};

Test case 3

int building[F][S] = {{12,12},{10,5},{3,7}};

int entry[5] = {1,1,1,1,5};

int exit[F][S] = {{1,2},{3,4}, {3,6}};

Test case 4

int building[F][S] = {{12,12},{12,12},{12,12}};

int entry[5] = {0,0,0,0,0};

int exit[F][S] = {{2,2},{3,3},{4,4}};

Test case 5

int building[F][S] = {{9,10},{7,8},{4,4}};

int entry[5] = {2,4,6,8,10};

int exit[F][S] = {{1,1},{1,1},{1,1}};
