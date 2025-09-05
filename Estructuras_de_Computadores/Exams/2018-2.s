/* Basic skeleton for programs using interrupts */

.include "configuration.inc" 
.include "symbolic.inc"

/* Vector Table inicialization */
	mov r0,#0
	ADDEXC 0x1C, fast_interrupt @only if used


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
	mov r1, #0b01100
	str r1,[r0,#GPFEN0]

	ldr r0,=INTBASE
	ldr r8, =0x0B4
	str r8,[r0,#INTFIQCON]
mov r1, #0b10010011
msr cpsr_c, r1

start:	ldr r0,=STBASE
	ldr r3,[r0,#STCLO]
	ldr r4, =1000000
	add r4, r3, r4
	ldr r5, =400

	
loop:ldr r0, =GPBASE  
	ldr r1, =0x010
	str r1,[r0,#GPSET0] 
	BL   wait
	str r1,[r0,#GPCLR0] 
	BL   wait
	ldr r0,=STBASE
	ldr r3,[r0,#STCLO]
	cmp r3, r4
	blt loop
	ldr r5, =800
	
	
	ldr r0,=STBASE
	ldr r3,[r0,#STCLO]
	ldr r4, =2000000
	add r4, r3, r4

	
loop2: ldr r0, =GPBASE  
	ldr r1, =0x010
	str r1,[r0,#GPSET0] 
	BL   wait
	str r1,[r0,#GPCLR0] 
	BL   wait
	ldr r0,=STBASE
	ldr r3,[r0,#STCLO]
	cmp r3, r4
	blt loop2
	
	ldr r0,=STBASE
	ldr r3,[r0,#STCLO]
	ldr r4, =3000000
	add r4, r3, r4
	ldr r5, =4000

	
loop3: ldr r0, =GPBASE  
	ldr r1, =0x010
	str r1,[r0,#GPSET0] 
	BL   wait
	str r1,[r0,#GPCLR0] 
	BL   wait
	ldr r0,=STBASE
	ldr r3,[r0,#STCLO]
	cmp r3, r4
	blt loop3


end:   b start

wait: PUSH {r3,r4,r7}
	ldr r7,=STBASE
	ldr r3,[r7,#STCLO]
	mov r4, r5
	add r4, r3, r4  
	b ret1
	
ret1: ldr r3,[r7,#STCLO]
	cmp r3,r4 
	blt ret1
	POP {r3,r4,r7}
	bx lr


fast_interrupt:
	push {r0, r1, r2, r3, r4,r5}
	
	
	ldr r0, =GPBASE
        ldr r6,= 0x8430E00
	str r6, [r0,#GPSET0]
	
	mov r1, #0b01100
	str r1, [r0,#GPEDS0]
	
	

        pop {r0, r1, r2, r3, r4}
	subs pc, lr, #4

onoff: .word 0
led: .word 0

	