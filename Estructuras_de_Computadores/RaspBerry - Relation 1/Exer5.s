.include "configuration.inc"
.include "symbolic.inc"

        mov     r0, #0b11010011
	msr     cpsr_c, r0
	mov     sp, #0x8000000
       ldr r0, =GPBASE
       ldr r1,= 0x600
       str r1,[r0,#GPSET0]
    
x:  
      ldr r1,= 0x200
      ldr r3,= 0x400
      
      ldr r2,[r0,#GPLEV0]
      tst r2,#0b00100
      streq r1,[r0,#GPCLR0]
      
      ldr r4,[r0,#GPLEV0]
      tst r4,#0b01000
      streq r3,[r0,#GPCLR0]
      
      b x
      
      
end: b end