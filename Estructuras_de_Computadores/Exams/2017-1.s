/* Basic skeleton for programs using ports (without interruptions) */

.include "configuration.inc" 
.include "symbolic.inc"

/* Stack init for SVC mode	*/
	mov     r0, #0b11010011
	msr     cpsr_c, r0
	mov     sp, #0x8000000
	
/* Continue my program here */

	ldr r0, =GPBASE
	ldr r1, =0x800
	str r1 ,[r0,#GPSET0] 
	
	x:  
      ldr r1,= 0x400
      ldr r2,[r0,#GPLEV0]
      tst r2,#0b00100
      streq r1,[r0,#GPSET0]
      strne r1,[r0,#GPCLR0]
	  
	  
	  ldr r3,=0x400000
	  ldr r4,[r0,#GPLEV0]
      tst r4,#0b01000
	  streq r3,[r0,#GPSET0]
	  beq sonido
    b x


end:   b end

sonido: ldr r0, =GPBASE
        ldr r1, =0x010
        loop:   str r1,[r0,#GPSET0]
				BL wait
				str r1,[r0,#GPCLR0]
				BL wait
				B loop 

wait: 	PUSH {r3,r4,r7}
		ldr r7,=STBASE
		ldr r3,[r7,#STCLO]
		ldr r4, =250
		add r4, r3, r4
		
ret1: 	ldr r3,[r7,#STCLO]
		cmp r3,r4
		blt ret1
		POP {r3,r4,r7}
		bx lr