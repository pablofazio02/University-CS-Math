/* Basic skeleton for programs using interrupts */

.include "configuration.inc" 
.include "symbolic.inc"

/* Vector Table inicialization */
	mov r0,#0
	ADDEXC 0x18, regular_interrupt 


/* Stack init for IRQ mode */	
	mov     r0, #0b11010010   
	msr     cpsr_c, r0
	mov     sp, #0x8000
/* Stack init for FIQ mode */	
	mov     r0, #0b11010001
	msr     cpsr_c, r0
	mov     sp, #0x4000
		mov r8,#0
/* Stack init for SVC mode	*/
	mov     r0, #0b11010011
	msr     cpsr_c, r0
	mov     sp, #0x8000000
	
/* Continue my program here */

	ldr r0, =STBASE
	ldr r1, [r0, #STCLO]
	add r1, #0x25000
	str r1, [r0, #STC1]

	ldr r0, =INTBASE
	mov r1, #0b1010
	str r1, [r0, #INTENIRQ1]

	mov r0, #0b01010011
	msr cpsr_c, r0

end:  b end

regular_interrupt:
	push {r0, r1, r2, r3, r4,r5}

	ldr r0, =GPBASE
	ldr r1, =led
	ldr r2, [r1]

	cmp r2, #0
	ldreq r1, =0x800000000

	cmp r2, #1
	ldreq r1, =0x4000000

	cmp r2, #2
	ldreq r1, =0x20000

	cmp r2, #3
	ldreq r1, =0x800

	cmp r2, #4
	ldreq r1, =0x400

	cmp r2, #5
	beq ganar

	ldr r4, =onoff
	ldr r3, [r4]
	eors r3, #1
	str r3, [r4]

	strne r1, [r0, #GPSET0]
	streq r1, [r0, #GPCLR0]

	cmp r3, #0
	
	addeq r2, #1
	cmp r2, #6
	subeq r2, #6

	ldr r1, =led
	str r2, [r1]

	ldr r0, =STBASE
	mov r1, #0b0010
	str r1, [r0, #STCS]
	ldr r1, [r0, #STCLO]
	add r1, #0x25000
	str r1, [r0, #STC1]

	ldr r5, [r0, #STCS]
	cmp r5, #0b1000
	bne fin

fin:	pop {r0, r1, r2, r3, r4}
	subs pc, lr, #4

onoff: .word 0
led: .word 0

	