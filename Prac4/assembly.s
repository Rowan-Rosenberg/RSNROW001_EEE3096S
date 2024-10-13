/*
 * assembly.s
 *
 */
 
 @ DO NOT EDIT
	.syntax unified
    .text
    .global ASM_Main
    .thumb_func

@ DO NOT EDIT
vectors:
	.word 0x20002000
	.word ASM_Main + 1

@ DO NOT EDIT label ASM_Main
ASM_Main:

	@ Some code is given below for you to start with
	LDR R0, RCC_BASE  		@ Enable clock for GPIOA and B by setting bit 17 and 18 in RCC_AHBENR
	LDR R1, [R0, #0x14]
	LDR R2, AHBENR_GPIOAB	@ AHBENR_GPIOAB is defined under LITERALS at the end of the code
	ORRS R1, R1, R2
	STR R1, [R0, #0x14]

	LDR R0, GPIOA_BASE		@ Enable pull-up resistors for pushbuttons
	MOVS R1, #0b01010101
	STR R1, [R0, #0x0C]
	LDR R1, GPIOB_BASE  	@ Set pins connected to LEDs to outputs
	LDR R2, MODER_OUTPUT
	STR R2, [R1, #0]
	MOVS R2, #0         	@ NOTE: R2 will be dedicated to holding the value on the LEDs

@ TODO: Add code, labels and logic for button checks and LED patterns

main_loop:

	LDR R6, GPIOA_BASE
	LDR R5, [R6, #0x10]	@ Loads PB inputs

	MOV R4, R5
	MOVS R6, #0b1000
	ANDS R4, R4, R6	@ Check PB3
	BEQ pb_3

	MOV R4, R5
	MOVS R6, #0b100
	ANDS R4, R4, R6	@ Check PB2
	BEQ pb_2

	MOV R4, R5
	MOVS R6, #0b1
	ANDS R4, R4, R6	@ Check PB0
	BEQ pb_0

	MOV R4, R5
	MOVS R6, #0b10
	ANDS R4, R4, R6	@ Check PB1
	BEQ pb_1

	@ NO pushbuttons pressed
	LDR R7, LONG_DELAY_CNT
	ADDS R2, R2, #1		@ increment led by 1
	B delay				@ Start 0.7s delay

pb_0:
	ADDS R2, R2, #2		@ increment led by 2

	MOV R4, R5
	MOVS R6, #0b10
	ANDS R4, R4, R6	@ Check PB1
	BEQ pb_0_and_1

	LDR R7, LONG_DELAY_CNT
	B delay		@ Start 0.7s delay

pb_0_and_1:
	LDR R7, SHORT_DELAY_CNT
	B delay		@ Start 0.3s delay

pb_1:
	LDR R7, SHORT_DELAY_CNT
	ADDS R2, R2, #1		@ increment led by 1
	B delay				@ Start 0.3s delay

pb_2:
	MOVS R2,#0xAA
	B write_leds

pb_3:
	B main_loop

delay:
	SUBS R7, #1
	BNE delay	@ Wait for count to reach 0
	B write_leds

write_leds:
	STR R2, [R1, #0x14]
	B main_loop

@ LITERALS; DO NOT EDIT
	.align
RCC_BASE: 			.word 0x40021000
AHBENR_GPIOAB: 		.word 0b1100000000000000000
GPIOA_BASE:  		.word 0x48000000
GPIOB_BASE:  		.word 0x48000400
MODER_OUTPUT: 		.word 0x5555

@ TODO: Add your own values for these delays
LONG_DELAY_CNT: 	.word 1400000
SHORT_DELAY_CNT: 	.word 600000

