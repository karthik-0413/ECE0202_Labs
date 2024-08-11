;******************** (C) Yifeng ZHU *******************************************
; @file    main.s
; @author  Yifeng Zhu
; @date    May-17-2015
; @note
;           This code is for the book "Embedded Systems with ARM Cortex-M 
;           Microcontrollers in Assembly Language and C, Yifeng Zhu, 
;           ISBN-13: 978-0982692639, ISBN-10: 0982692633
; @attention
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
	
	BL System_Clock_Init
	BL UART2_Init



;;;;;;;;;;;; YOUR CODE GOES HERE    ;;;;;;;;;;;;;;;;;;;

      ; Configuring Peripherals (Clocks and GPIOs)

      LDR   r0, =RCC_BASE ; Configuring the reset and clock of the microcontroller
      LDR   r1, [r0, #RCC_AHB2ENR] ; Loading the value of the clock onto r1
      ORR   r1, r1, #0x00000006 ; Masking the GPIOB and GPIOC to enable the clock
      BIC   r1, r1, #0x00000001 ; Setting the desired GPIOs (GPIOB and GPIOC)
      STR   r1, [r0, #RCC_AHB2ENR] ; Storing the value of the clock to r1
      

      LDR   r0, =GPIOB_BASE ; Configuring the MODER resgisters in GPIOB for INPUTS
      LDR   r1, [r0, #GPIO_MODER] ; Loading the value of the MODER onto r1
      MOV   r2, #0x00000CFC ; Moving the desired value into r2
      BIC   r1, r2  ; Clearing all values and storing it in r1
      STR   r1, [r0, #GPIO_MODER] ; Storing the value of the MODER to r1
      

      LDR   r0, =GPIOC_BASE ; Configuring the MODER resgisters in GPIOC for OUTPUTS
      LDR   r1, [r0, #GPIO_MODER] ; Loading the value of the MODER onto r1
      BIC   r1, r1, #0x000000FF ; Masking the registers that we are interested in
      ORR   r1, r1, #0x00000055 ; Setting the desired resgisters
      STR   r1, [r0, #GPIO_MODER] ; Storing the value of the MODER to r1
      
; subrountine that goes through the input values and sees which ODR is pulled down
machi_cout
      
      LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
      LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
      BIC r1, #0x0000000F ; Masking the registers that we are interested in
      STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1

      BL delay  ; Branching to delay function as per the flowchart
      

      LDR r0, =GPIOB_BASE ; Configuring the IDR resgister in GPIOB for INPUTS
      LDR r2, [r0, #GPIO_IDR]  ; Loading the current value of IDR into r2
      
      CMP r2, #0x0000003E ; Comparing the value if nothing is pressed
      BEQ machi_cout ; If equal, then go to subrountine that pulls row 1 down 
	  
      LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
      LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
      BIC r1, #0x0000000F ; Masking the registers that we are interested in
      ORR r1, #0x0000000E ; Setting the first bit to 0 to pull first row low
      STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
      
      BL delay  ; Branching to delay function as per the flowchart
      

      LDR r0, =GPIOB_BASE ; Configuring the IDR resgister in GPIOB for INPUTS
      LDR r2, [r0, #GPIO_IDR]  ; Loading the current value of IDR into r2
      
      CMP r2, #0x0000003E ; Comparing the value if nothing is pressed
      BNE mapillai ; If not equal, then branch back to top of this loop
	  
	  LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
      LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
      BIC r1, #0x0000000F ; Masking the registers that we are interested in
      ORR r1, #0x0000000D ; Setting the first bit to 0 to pull second row low
      STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
      
      BL delay  ; Branching to delay function as per the flowchart
      

      LDR r0, =GPIOB_BASE ; Configuring the IDR resgister in GPIOB for INPUTS
      LDR r2, [r0, #GPIO_IDR]  ; Loading the current value of IDR into r2
      
      CMP r2, #0x0000003E ; Comparing the value if nothing is pressed
      BNE mapillai ; If not equal, then branch back to top of this loop
	  
	  LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
      LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
      BIC r1, #0x0000000F ; Masking the registers that we are interested in
      ORR r1, #0x0000000B ; Setting the first bit to 0 to pull third row low
      STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
      
      BL delay  ; Branching to delay function as per the flowchart
      

      LDR r0, =GPIOB_BASE ; Configuring the IDR resgister in GPIOB for INPUTS
      LDR r2, [r0, #GPIO_IDR]  ; Loading the current value of IDR into r2
      
      CMP r2, #0x0000003E ; Comparing the value if nothing is pressed
      BNE mapillai ; If not equal, then branch back to top of this loop
	  
	  LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
      LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
      BIC r1, #0x0000000F ; Masking the registers that we are interested in
      ORR r1, #0x00000007 ; Setting the first bit to 0 to pull fourth row low
      STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
      
      BL delay  ; Branching to delay function as per the flowchart
      

      LDR r0, =GPIOB_BASE ; Configuring the IDR resgister in GPIOB for INPUTS
      LDR r2, [r0, #GPIO_IDR]  ; Loading the current value of IDR into r2
      
      CMP r2, #0x0000003E ; Comparing the value if nothing is pressed
      BEQ machi_cout ; If equal, then go to subrountine that checks to see what exact value has been pressed

; subroutine that checks which column makes the row column zero
mapillai
      BIC r5,r5 ; Clearing r5 so that the value register is reset

      CMP r1, #0x0000000E   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xE
	  BNE part2
      CMP r2, #0x0000003C ; If so, then nested compare statement that sees if the column one has been pressed
      LDREQ r7, =one ; If so, loading the ASCII value of one into r7
      MOVEQ r5, #049 ; If so, moving the ASCII value of one into r5
      BEQ displaykey ; If so, branching to displaykey
      
      CMP r2, #0x0000003A ; If so, then nested compare statement that sees if the column two has been pressed
      LDREQ r7, =two ; If so, loading the ASCII value of two into r7
      MOVEQ r5, #050 ; If so, moving the ASCII value of two into r5
      BEQ displaykey ; If so, branching to displaykey
     
     
      CMP r2, #0x00000036 ; If so, then nested compare statement that sees if the column third has been pressed
      LDREQ r7, =three ; If so, loading the ASCII value of three into r7
      MOVEQ r5, #051 ; If so, moving the ASCII value of three into r5
      BEQ displaykey ; If so, branching to displaykey
      
      CMP r2, #0x0000001E ; If so, then nested compare statement that sees if the column fourth has been pressed
      LDREQ r7, =LetterA ; If so, loading the ASCII value of A into r7
      MOVEQ r5, #065 ; If so, moving the ASCII value of A into r5
      BEQ displaykey ; If so, branching to displaykey

part2
   
      CMP r1, #0x0000000D   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xD
      BNE part3
      CMPEQ r2, #0x0000003C ; If so, then nested compare statement that sees if the column one has been pressed
      LDREQ r7, =four ; If so, loading the ASCII value of four into r7
      MOVEQ r5, #052 ; If so, moving the ASCII value of four into r5
      BEQ displaykey ; If so, branching to displaykey
      
      CMP r2, #0x0000003A ; If so, then nested compare statement that sees if the column two has been pressed
      LDREQ r7, =five ; If so, loading the ASCII value of five into r7
      MOVEQ r5, #053 ; If so, moving the ASCII value of five into r5
      BEQ displaykey ; If so, branching to displaykey
      
      CMP r2, #0x00000036 ; If so, then nested compare statement that sees if the column third has been pressed
      LDREQ r7, =six ; If so, loading the ASCII value of six into r7
      MOVEQ r5, #054 ; If so, moving the ASCII value of six into r5
      BEQ displaykey ; If so, branching to displaykey
      
      
      CMP r2, #0x0000001E ; If so, then nested compare statement that sees if the column fourth has been pressed
      LDREQ r7, =LetterB ; If so, loading the ASCII value of B into r7
      MOVEQ r5, #066 ; If so, moving the ASCII value of B into r5
      BEQ displaykey ; If so, branching to displaykey
      
part3

      CMP r1, #0x0000000B   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xB
      BNE part4
      CMPEQ r2, #0x0000003C ; If so, then nested compare statement that sees if the column one has been pressed
      LDREQ r7, =seven ; If so, loading the ASCII value of seven into r7
      MOVEQ r5, #055 ; If so, moving the ASCII value of seven into r5
      BEQ displaykey ; If so, branching to displaykey
      
      CMPEQ r2, #0x0000003A ; If so, then nested compare statement that sees if the column two has been pressed
      LDREQ r7, =eight ; If so, loading the ASCII value of eight into r7
      MOVEQ r5, #056 ; If so, moving the ASCII value of eight into r5
      BEQ displaykey ; If so, branching to displaykey
      
      CMPEQ r2, #0x00000036 ; If so, then nested compare statement that sees if the column third has been pressed
      LDREQ r7, =nine ; If so, loading the ASCII value of nine into r7
      MOVEQ r5, #057 ; If so, moving the ASCII value of nine into r5
      BEQ displaykey ; If so, branching to displaykey
      
      CMPEQ r2, #0x0000001E ; If so, then nested compare statement that sees if the column fourth has been pressed
      LDREQ r7, =LetterC ; If so, loading the ASCII value of C into r7
      MOVEQ r5, #067 ; If so, moving the ASCII value of C into r5
      BEQ displaykey ; If so, branching to displaykey

part4
      
      CMP r2, #0x0000003C ; If so, then nested compare statement that sees if the column one has been pressed
      LDREQ r7, =astersik ; If so, loading the ASCII value of * into r7
      MOVEQ r5, #042 ; If so, moving the ASCII value of * into r5
      BEQ displaykey ; If so, branching to displaykey
      
      CMP r2, #0x0000003A ; If so, then nested compare statement that sees if the column two has been pressed
      LDREQ r7, =zero ; If so, loading the ASCII value of zero into r7
      MOVEQ r5, #048 ; If so, moving the ASCII value of zero into r5
      BEQ displaykey ; If so, branching to displaykey


      CMP r2, #0x00000036 ; If so, then nested compare statement that sees if the column third has been pressed
      LDREQ r7, =Pound ; If so, loading the ASCII value of # into r7
      MOVEQ r5, #035 ; If so, moving the ASCII value of # into r5
      BEQ displaykey ; If so, branching to displaykey
      
      CMP r2, #0x0000001E ; If so, then nested compare statement that sees if the column fourth has been pressed
      LDREQ r7, =LetterD ; If so, loading the ASCII value of D into r7
      MOVEQ r5, #068 ; If so, moving the ASCII value of D into r5
      BEQ displaykey ; If so, branching to displaykey
      
; button_press subroutine that waits until button has been pressed to display value in Tera Term
displaykey
	  LDR r0, =GPIOB_BASE ; Configuring the resgister in GPIOB for INPUTS               
      LDR r1, =GPIOC_BASE ; Configuring the resgister in GPIOC for OUTPUTS
      LDR r2, [r0, #GPIO_IDR] ; Loading the current value of the IDR into r3 
      CMP r2, #0x0000003E ; Comparing the value of the IDR to 0x3E, which means that all of the input bits are one (Nothing is pressed)
      BNE displaykey ; Recursively calling the button_press function until the button has been released 
      STR r5, [r8]  ; Goes onto given display function if the button is not pressed
      MOV r0, r7
      MOV r1, #1   ; Second arugment                           
      BL USART2_Write   ; Writes value to Tera Term
      B machi_cout  ; Branches back to machi_cout subroutine

; delay subroutine (no args)
delay PROC
      ; Delay for software debouncing
      LDR r9, =0x9999
delayloop
      SUBS r9, #1
      BNE delayloop
      BX LR
      ENDP
           
      AREA myData, DATA, READWRITE
      ALIGN

; Creating memory space for the corresponding ASCII values of 0-9, A-D, *, and #. 
zero DCD 48
one DCD 49
two DCD 50
three DCD 51
four DCD 52
five DCD 53
six DCD 54
seven DCD 55
eight DCD 56
nine DCD 57
LetterA DCD 65
LetterB DCD 66
LetterC DCD 67
LetterD DCD 68
astersik DCD 42
Pound DCD 35

    END
