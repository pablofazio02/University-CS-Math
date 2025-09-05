
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

inicio: 	
		ldr r0, =GPBASE
		green2ON
		ldr r1, [r0, #GPLEV0]
		tst r1, #0b0100
		beq iniciar
		
		b inicio

iniciar:	
		ldr r0, =GPBASE
		mov r1, #0b01100
		str r1, [r0,#GPFEN0]  
	
		ldr r0, =INTBASE 
		ldr r1, =0x00100000
		str r1,[r0,#INTENIRQ2] 
	
		ldr r0, =STBASE
		ldr r1, [r0,#STCLO]
		add r1, #0x500000
		str r1,[r0,#STC3]
      
		ldr r0, =INTBASE
		ldr r1,=0x083
		str r1, [r0, #INTFIQCON]
     
		mov r1, #0b00010011
		msr cpsr_c, r1 
	
		green1ON
		mov r8, #0
		mov r6, #0

end:   b end

regular_interrupt: 
	push {r0,r1,r2,r3}

	ldr r0, =GPBASE
	ldr r2, [r0,#GPEDS0]
	tst r2,#0b00100
	
	push {lr}
	blne siguienteLED
	blne wait1000
	pop {lr}
	
	ldr r0, =GPBASE 
	ldr r3, [r0,#GPEDS0]
	tst r3,#0b01000
	
	push {lr}
	blne rojo
	blne wait1000
	pop {lr}
	
	cuerpo:	cmp r8, #0
			ldrne r5, =5000000
			movne r6, #1
	
			ldr r0, =GPBASE 
			mov r1, #0b01100
			str r1,[r0,#GPEDS0] 
	
			ldr r0, =STBASE
			ldr r1, [r0, #STCLO]
			add r1, r5, r1
			str r1, [r0, #STC1] 
	
			ldr r0, =STBASE
			mov r1, #0b0010
			str r1,[r0,#STCS] 

	pop {r0,r1,r2,r3}
	subs  pc, lr, #4
	
		
fast_interrupt: 
	push {lr}
	
	b perder
	
	pop {lr}
	subs  pc, lr, #4	
	
siguienteLED:

	push {lr}
	
	add r8, #1
	ldr r0, =GPBASE
	
	cmp r8, #1
	green1ON
	
	cmp r8, #2
	green1OFF
	yellow2ON
	
	cmp r8, #3
	yellow2OFF
	yellow1ON
	
	cmp r8, #4
	yellow1OFF
	red2ON
	
	cmp r8, #5
	beq ganar
	
	pop {lr}
	bx lr

rojo:
		green2OFF
		red1ON
		
		push {lr}
		bl espera
		pop {lr}
		
		red1OFF
		green2ON
	
		bx lr
	
perder:
		red1ON
		ldr r0, =GPBASE
		ldr r1, =0x010
		
		str r1,[r0,#GPSET0]
		bl wait
		str r1,[r0,#GPCLR0]
		bl wait
		
		b perder

ganar:
		mov r1, #0b11010011
		msr cpsr_c, r1 
		
		encenderLEDS
		bl wait1000
		apagarLEDS
		bl wait1000
		
		b ganar

espera:
		push {r0,r2,r3,r4,r7}
		ldr r7, =STBASE
		ldr r3, [r7,#STCLO]
		ldr r4, = 500000
		add r4, r3, r4
	
		ret: 
			ldr r0, =GPBASE
			ldr r2, [r0,#GPEDS0]
			tst r2,#0b00100

			blne perder
	
			ldr r3, [r7,#STCLO]
			ldr r3, [r7,#STCLO]
			cmp r3, r4
			blt ret
	
	pop {r0,r2,r3,r4,r7}
	bx lr	
		
wait:  	PUSH {r3,r4,r7}
		ldr r7, = STBASE
		ldr r3, [r7,#STCLO]
		ldr r4, = 200
		add r4,r3,r4

		ret3: ldr r3, [r7,#STCLO]
		      cmp r3,r4
			  blt ret3
				
		POP {r3,r4,r7}
		bx lr
		
wait200:	PUSH {r3,r4,r7}
			ldr r7, = STBASE
			ldr r3, [r7,#STCLO]
			ldr r4, = 20000
			add r4,r3,r4

			ret2: ldr r3, [r7,#STCLO]
				  cmp r3,r4
				  blt ret2
				  
			POP {r3,r4,r7}
			bx lr
		
wait1000:  	PUSH {r3,r4,r7}
			ldr r7, = STBASE
			ldr r3, [r7,#STCLO]
			ldr r4, = 500000
			add r4,r3,r4

			ret5: ldr r3, [r7,#STCLO]
				  cmp r3,r4
				  blt ret5
				  
			POP {r3,r4,r7}
			bx lr


	

