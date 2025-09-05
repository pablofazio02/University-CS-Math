/* Basic skeleton for programs using ports (without interruptions) */

.include "configuration.inc" 
.include "symbolic.inc"

/* Stack init for SVC mode	*/
	mov     r0, #0b11010011
	msr     cpsr_c, r0
	mov     sp, #0x8000000
	
/* Continue my program here */

		ldr r0, =GPBASE
		ldr r1,=0x010

		ldr r7,=STBASE
		ldr r3,[r7,#STCLO]
		ldr r4, =2000000   @ k segundos emitidos = k * 10^6
		add r4, r3, r4

	
loop: 	str r1,[r0,#GPSET0]
		BL wait
		str r1,[r0,#GPCLR0]
		BL wait
	
		ldr r3,[r7,#STCLO]
		cmp r3,r4
		blt loop

/* Continue my program here */

end:  	b end

wait:
	PUSH {r3,r4,r7}
	ldr r7,=STBASE
	ldr r3,[r7,#STCLO]
	ldr r4, =500 @ microsegundos = (1 / Frencuencia (Hz) * 10^6)/2
	add r4, r3, r4
ret1:
	ldr r3,[r7,#STCLO]
	cmp r3,r4
	blt ret1
	POP {r3,r4,r7}
	bx lr
	
	
	


	