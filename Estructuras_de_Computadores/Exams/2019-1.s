/* Basic skeleton for programs using ports (without interruptions) */

.include "configuration.inc" 
.include "symbolic.inc"

/* Stack init for SVC mode	*/
	mov     r0, #0b11010011
	msr     cpsr_c, r0
	mov     sp, #0x8000000
	
/* Continue my program here */

	ldr r0, =GPBASE
	ldr r1, =0xE0800
	str r1 ,[r0,#GPSET0]
	
x:
	ldr r2, =0b1000010000000000011000000000
	ldr r3, =0xE0800
	ldr r1, [r0,#GPLEV0]
	tst r1,#0b00100
	streq r2, [r0, #GPSET0]
	streq r3, [r0,#GPCLR0]
	
	ldr r4, [r0,#GPLEV0]
	tst r4,#0b01000
	bleq loop
	b x

loop: 
	ldr r1, =0x010
	str r1,[r0,#GPSET0] 
	BL wait 
	str r1,[r0,#GPCLR0] 
	BL wait 
	B x


wait:
		ldr r5, =700
loop2: 	subs r5, #1
		bne loop2
		bx lr

end:   b end
