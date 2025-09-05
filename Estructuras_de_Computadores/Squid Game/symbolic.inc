      .macro    ADDEXC  vector, dirRTI
        ldr     r1, =(\dirRTI-\vector+0xa7fffffb)
        ror     r1, #2
        str     r1, [r0, #\vector]
      .endm
	  
	  .macro red1ON
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x0200
	  str r1,[r0,#GPSET0]
	  pop {r0,r1}
	 .endm
	 
	 .macro red1OFF
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x0200
	  str r1,[r0,#GPCLR0]
	  pop {r0,r1}
	 .endm
	 
	 .macro red2ON
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x0400
	  str r1,[r0,#GPSET0]
	  pop {r0,r1}
	 .endm
	 
	 .macro red2OFF
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x0400
	  str r1,[r0,#GPCLR0]
	  pop {r0,r1}
	 .endm
	 
	  .macro yellow1ON
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x0800
	  str r1,[r0,#GPSET0]
	  pop {r0,r1}
	 .endm
	 
	  .macro yellow1OFF
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x0800
	  str r1,[r0,#GPCLR0]
	  pop {r0,r1}
	 .endm
	 
	 .macro yellow2ON
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x020000
	  str r1,[r0,#GPSET0]
	  pop {r0,r1}
	 .endm
	 
	 .macro yellow2OFF
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x020000
	  str r1,[r0,#GPCLR0]
	  pop {r0,r1}
	 .endm
	 
	 .macro green1ON
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x0400000
	  str r1,[r0,#GPSET0]
	  pop {r0,r1}
	 .endm
	 
	 .macro green1OFF
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x0400000
	  str r1,[r0,#GPCLR0]
	  pop {r0,r1}
	 .endm
	 
	 .macro green2ON
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x8000000
	  str r1,[r0,#GPSET0]
	  pop {r0,r1}
	 .endm
	 
	 .macro green2OFF
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x8000000
	  str r1,[r0,#GPCLR0]
	  pop {r0,r1}
	 .endm
	 
	 .macro apagarLEDS
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x8420E00
	  str r1,[r0,#GPCLR0]
	  pop {r0,r1}
	 .endm

	.macro encenderLEDS
      push {r0,r1}
	  ldr r0,=GPBASE
	  ldr r1, =0x8420E00
	  str r1,[r0,#GPSET0]
	  pop {r0,r1}
	 .endm
	 
	 
	 
        .set    GPBASE,   0x3f200000
        .set    GPFSEL0,        0x00
        .set    GPFSEL1,        0x04
        .set    GPFSEL2,        0x08
        .set    GPFSEL3,        0x0c
        .set    GPFSEL4,        0x10
        .set    GPFSEL5,        0x14
        .set    GPFSEL6,        0x18
        .set    GPSET0,         0x1c
        .set    GPSET1,         0x20
        .set    GPCLR0,         0x28
        .set    GPCLR1,         0x2c
        .set    GPLEV0,         0x34
        .set    GPLEV1,         0x38
        .set    GPEDS0,         0x40
        .set    GPEDS1,         0x44
        .set    GPFEN0,         0x58
        .set    GPFEN1,         0x5c
        .set    GPPUD,          0x94
        .set    GPPUDCLK0,      0x98
        .set    STBASE,   0x3f003000
        .set    STCS,           0x00
        .set    STCLO,          0x04
        .set    STC1,           0x10
        .set    STC3,           0x18
        .set    INTBASE,  0x3f00b000
        .set    INTFIQCON,     0x20c
        .set    INTENIRQ1,     0x210
        .set    INTENIRQ2,     0x214
