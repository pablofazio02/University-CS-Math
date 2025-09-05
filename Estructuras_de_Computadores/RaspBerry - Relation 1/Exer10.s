.include "configuration.inc"
.include "symbolic.inc"

        mov     r0, #0b11010011
	msr     cpsr_c, r0
	mov     sp, #0x8000000
        ldr r0, =GPBASE
        ldr r1,= 0x010

x:   

      ldr r2,[r0,#GPLEV0]
      tst r2,#0b00100
      beq loop1
      
      ldr r4,[r0,#GPLEV0]
      tst r4,#0b01000
      beq loop2
      
     b x

loop1: PUSH {r0,r1}
        str r1,[r0,#GPSET0]
        BL wait1
	str r1,[r0,#GPCLR0]
	BL wait1
	POP {r0,r1}
	B loop1
	
loop2: PUSH {r0,r1}
        str r1,[r0,#GPSET0]
        BL wait2
	str r1,[r0,#GPCLR0]
	BL wait2
	POP {r0,r1}
	B loop2


wait1: PUSH {r3,r4,r7}
	ldr r7, = STBASE
        ldr r3, [r7,#STCLO]
	ldr r4, = 1908
	add r4,r3,r4
	
	ret1: ldr r3, [r7,#STCLO]
	        cmp r3,r4
		blt ret1
		POP {r3,r4,r7}
		bx lr
		
wait2: PUSH {r3,r4,r7}
        ldr r7, = STBASE
        ldr r3, [r7,#STCLO]
	ldr r4, = 1278
	add r4,r3,r4
	
	ret2: ldr r3, [r7,#STCLO]
	        cmp r3,r4
		blt ret2
		POP {r3,r4,r7}
		bx lr

end: b end