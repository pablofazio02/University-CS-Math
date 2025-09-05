/* Basic skeleton for programs using ports (without interruptions) */

.include "configuration.inc" 
.include "symbolic.inc"

/* Stack init for SVC mode	*/
	mov     r0, #0b11010011
	msr     cpsr_c, r0
	mov     sp, #0x8000000
	
/* Continue my program here */
       
       ldr r0,=GPBASE
       ldr r1, =0x8430E00
       str r1, [r0,#GPSET0]

 x:      ldr r1,[r0,#GPLEV0]
          tst r1,#0b00100
          beq apagar
	  
	  b x
       

end:   b end

apagar:

	ldr r0,=GPBASE
        ldr r3, =0x200
	str r3, [r0,#GPCLR0]
	BL wait
	ldr r3, =0x400
	str r3, [r0,#GPCLR0]
	BL wait
	ldr r3, =0x800
	str r3, [r0,#GPCLR0]
	BL wait
	ldr r3, =0x30000
	str r3, [r0,#GPCLR0]
	BL wait
	ldr r3, =0x400000
	str r3, [r0,#GPCLR0]
	BL wait
	ldr r3, =0x8000000
	str r3, [r0,#GPCLR0]
	
	ldr r0,=GPBASE
	ldr r1,=0x010
	
	bl musica
	
	
musica: str r1,[r0,#GPSET0]
            BL wait2
	    str r1,[r0,#GPCLR0]
	    BL wait2
	    B musica


wait:	PUSH {r3,r4,r7}
	ldr r7,=STBASE
	ldr r3,[r7,#STCLO]
	ldr r4, =200000
	add r4, r3, r4
	
ret1: ldr r3,[r7,#STCLO]
	cmp r3,r4
	blt ret1
	POP {r3,r4,r7}
	bx lr


wait2:PUSH {r3,r4,r7}
	ldr r7,=STBASE
	ldr r3,[r7,#STCLO]
	ldr r4, =500
	add r4, r3, r4
ret2: ldr r3,[r7,#STCLO]
	cmp r3,r4
	blt ret2
	POP {r3,r4,r7}
	bx lr