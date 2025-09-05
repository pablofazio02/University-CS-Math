
.include "configuration.inc" 
.include "symbolic.inc"

/* Vector Table inicialization */
	mov r0,#0
	ADDEXC 0x18, regular_interrupt 
	ADDEXC 0x1C, fast_interrupt      


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
	ldr r1,[r0, #STCLO]
	add r1, #0x50000
	str r1, [r0, #STC3]
	str r1, [r0, #STC1]
	
	ldr r0, =INTBASE
	mov r1, #0b10000011 
	str r1, [r0, #INTFIQCON] 
	mov r1, #0b0010
	str r1, [r0, #INTENIRQ1]
	
	mov r0, #0b00010011
	msr cpsr_c, r0
	
end: b end

fast_interrupt: 
	push {r0,r1,r2,r3}
	
	ldr r0, =GPBASE
	ldr r1, =onoff
	
	ldr r2, [r1]
	eors r2, #1
	str r2, [r1]
	
	ldr r1,= 0b10000
	streq r1, [r0, #GPCLR0]
	strne r1, [r0, #GPSET0]
	
	ldr r0, = STBASE
	mov r1, #0b1000
	str r1, [r0, #STCS]
	
	ldr r2, =led
	ldr r1, [r2]
	
	ldr r2, =notas
	ldr r3, [r2,r1]
	
	ldr r1, [r0, #STCLO]
	add r1, r3
	str r1, [r0, #STC3]

	pop {r0,r1,r2,r3}
	subs  pc, lr, #4


regular_interrupt: 
	push {r0,r1,r2,r3}
	
	ldr r0, =GPBASE
	
	ldr r3, =0b00001000010000100000111000000000
	str r3, [r0, #GPCLR0]
	
	ldr r2, =led
	ldr r1, [r2]
	
	add r1, #4
	cmp r1, #24
	subge r1, #24
	
	str r1, [r2]
	ldr r2, =desp
	ldr r1, [r2]
	
	add r1, #4
	cmp r1, #24
	subge r1, #24
	
	str r1, [r2]
	ldr r2, =array
	ldr r3, [r2,r1]
	
	str r3, [r0, #GPSET0]
	ldr r0, =STBASE
	mov r1, #0b0010
	str r1, [r0, #STCS]
	
	ldr r2, [r0, #STCLO]
	ldr r1, =500000
	add r2,r1
	str r2, [r0, #STC1]

	pop {r0,r1,r2,r3}
	subs  pc, lr, #4
	
array:  .word 0x200
           .word 0x400
	   .word 0x800
	   .word 0x20000
	   .word 0x400000
	   .word 0x8000000

onoff: .word 0
led: .word 0
desp: .word 0

notas: .word 1984
           .word 1706
	   .word 1515
	   .word 1351
	   .word 1276
	   .word 1136