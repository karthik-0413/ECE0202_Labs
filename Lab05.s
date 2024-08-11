;******************** (C) Yifeng ZHU *******************************************
; @file    main.s
; @author  Yifeng Zhu
; @date    May-17-2015
; @note
;           This code is for the book "Embedded Systems with ARM Cortex-M 
;           Microcontrollers in Assembly Language and C, Yifeng Zhu, 
;           ISBN-13: 978-0982692639, ISBN-10: 0982692633
; @attension
;           This code is provided for education purpose. The author shall not be 
;           held liable for any direct, indirect or consequential damages, for any 
;           reason whatever. More information can be found from book website: 
;           http:;www.eece.maine.edu/~zhu/book
;*******************************************************************************


	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s      

	IMPORT 	System_Clock_Init
	IMPORT 	UART2_Init
	IMPORT	USART2_Write
	
	AREA    main, CODE, READONLY
	EXPORT	__main				; make __main visible to linker
	ENTRY			
				
__main	PROC
	
	;	Enable clocks for GPIOC, GPIOB//;	Enable clocks for GPIOA, GPIOB
		
	; Set GPIOC pin 13 (blue button) as an input pin//; Set GPIOA pin 0 (center joystick button) as an input pin
	
	; Set GPIOB pins 2, 3, 6, 7 as output pins
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;; YOUR CODE GOES HERE ;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
	
	LDR   r0, =RCC_BASE ; Configuring the reset and clock of the microcontroller
	LDR   r1, [r0, #RCC_AHB2ENR] ; Loading the value of the clock onto r1
	BIC   r1, r1, #0x00000001 ; Setting the desired GPIOs (GPIOB and GPIOC)
	ORR   r1, r1, #0x00000006 ; Masking the GPIOB and GPIOC to enable the clock
	STR   r1, [r0, #RCC_AHB2ENR] ; Storing the value of the clock to r1
	
	LDR   r0, =GPIOB_BASE ; Configuring the MODER resgisters in GPIOC for OUTPUTS
	LDR   r1, [r0, #GPIO_MODER] ; Loading the value of the MODER onto r1
	BIC   r1, r1, #0x000000FF ; Masking the registers that we are interested in
	ORR   r1, r1, #0x00000055 ; Setting the desired resgisters
	STR   r1, [r0, #GPIO_MODER] ; Storing the value of the MODER to r1
	
	LDR   r0, =GPIOC_BASE ; Configuring the MODER resgisters in GPIOB for INPUTS
	LDR   r1, [r0, #GPIO_MODER] ; Loading the value of the MODER onto r1
	BIC   r1, r1, #0x0C000000 ; Masking the registers that we are interested in
	ORR	  r1, r1, #0x00000000 ; Setting the desired resgisters
	STR   r1, [r0, #GPIO_MODER] ; Storing the value of the MODER to r1

machimain

	LDR r0, =GPIOC_BASE ; Configuring the IDR resgister in GPIOB for INPUTS
	LDR r2, [r0, #GPIO_IDR]  ; Loading the current value of IDR into r2
	CMP r2, #0x00002000	; Comparing the 13th bit on the IDR
	BEQ machimain	; If the compare statement is true, then return back to this subrountine
					; Else, continue to the 'windshield wiper' code
	
	
	
; delay subroutine (no args)
delay2 PROC
      ; Delay for software debouncing
      MOV r8, #207
delayloop2
    
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  BIC r1, #0x0000000A ; Masking the registers that we are interested in
	  ORR r1, #0x0000000A ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  AND r1, #0x00000000 ; Masking the registers that we are interested in
	  ORR r1, #0x00000006 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  AND r1, #0x00000000 ; Masking the registers that we are interested in
	  ORR r1, #0x00000005 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  AND r1, #0x00000000 ; Masking the registers that we are interested in
	  ORR r1, #0x00000009 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  SUBS r8, #1	; Subtracting the value of r8 by 1 each iteration
      BNE delayloop2	; Repeating the subroutine until r8 = 0
		  
		  
; delay subroutine (no args)
      ; Delay for software debouncing
      MOV r8, #207
delayloop3
      
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  AND r1, #0x00000000 ; Masking the registers that we are interested in
	  ORR r1, #0x00000009 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  AND r1, #0x00000000 ; Masking the registers that we are interested in
	  ORR r1, #0x00000005 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  AND r1, #0x00000000 ; Masking the registers that we are interested in
	  ORR r1, #0x00000006 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  AND r1, #0x00000000 ; Masking the registers that we are interested in
	  ORR r1, #0x0000000A ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  SUBS r8, #1	; Subtracting the value of r8 by 1 each iteration
      BNE delayloop3	; Repeating the subroutine until r8 = 0
      B machimain	; Branching back to the subroutine and checking the IDR
      ENDP	; Ending the process
		  
; delay subroutine (no args)
delay PROC
      ; Delay for software debouncing
      LDR r9, =5000
delayloop
      SUBS r9, #1	; Subtracting the value of r9 by 1 each iteration
      BNE delayloop	; Repeating the subroutine until r9 = 0
      BX LR	; Branching to the address in the Linked Register
      ENDP	; Ending the process
		
	ENDP	; Ending the process		
		
	
	ALIGN			

	AREA myData, DATA, READWRITE
	ALIGN
; Replace ECE1770 with your last name
str DCB "ECE1770",0
	END