.include "configuration.inc"
.include "symbolic.inc"


	mov     r0, #0b11010011
	msr     cpsr_c, r0
	mov     sp, #0x8000000
       
        ldr r0, =GPBASE
        ldr r1,= 0xE000D00
        str r1,[r0,#GPSET0]

    

end: b end