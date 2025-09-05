/* Basic skeleton for programs using interrupts */

.include "configuration.inc" 
.include "symbolic.inc"

/* Vector Table inicialization */
	mov r0,#0
	ADDEXC 0x1C, fast_interrupt      @only if used


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

		ldr r0, =GPBASE
		ldr r1,=0x010

		ldr r7,=STBASE
		ldr r3,[r7,#STCLO]
		ldr r4, =2000000
		add r4, r3, r4
	
		ldr r6, =4545
	
loop1: 	str r1,[r0,#GPSET0]
		BL wait1
		str r1,[r0,#GPCLR0]
		BL wait1
	
		ldr r3,[r7,#STCLO]
		cmp r3,r4
		blt loop1
		
		ldr r0, =GPBASE
		mov r1, #0b01100
		str r1,[r0,#GPFEN0]
		
		ldr r0, =INTBASE
		ldr r8, =0x0B4
		str r8, [r0, #INTFIQCON]
		
		mov r1, #0b10010011
		msr cpsr_c, r1
       
loop2:  str r1,[r0,#GPSET0]
		BL wait2
		str r1,[r0,#GPCLR0]
		BL wait2
		B loop2    

end:   b end

fast_interrupt: 
	push {r0,r1}
	
	ldr r0, =GPBASE
	ldr r1, [r0,#GPEDS0]
	tst r1,#0b00100
	beq bucle
	
	ldr r1, [r0,#GPEDS0]
	tst r1,#0b01000
	beq bucle
	
	ldr r0, =GPBASE
	mov r1, #0b01100
	str r1,[r0,#GPEDS0]

	pop {r0,r1}
	subs  pc, lr, #4


wait1:
		PUSH {r3,r4,r7}
		ldr r7,=STBASE
		ldr r3,[r7,#STCLO]
		ldr r4, =4545
		add r4, r3, r4
ret1:
		ldr r3,[r7,#STCLO]
		cmp r3,r4
		blt ret1
		POP {r3,r4,r7}
		bx lr
		
		
wait2:
		PUSH {r3,r4,r7}
		ldr r7,=STBASE
		ldr r3,[r7,#STCLO]
		ldr r4, =500
		add r4, r3, r4
ret2:
		ldr r3,[r7,#STCLO]
		cmp r3,r4
		blt ret2
		POP {r3,r4,r7}
		bx lr


bucle: 	mov r7, #0
		loop:
			ldr r0, =GPBASE
			ldr r6,= 0x8420E00
			eors r7, #1 
			streq r6, [r0,#GPSET0]
			strne r6, [r0,#GPCLR0]
			BL wait
			b loop
	
wait: 	PUSH {r3,r4,r7}
		ldr r7,=STBASE
		ldr r3,[r7,#STCLO]
		ldr r4, =100000
		add r4, r3, r4
ret:
		ldr r3,[r7,#STCLO]
		cmp r3,r4
		blt ret
		POP {r3,r4,r7}
		bx lr
	
	
	
	