INCLUDE core_cm4_constants.s
INCLUDE stm32l476xx_constants.s      
IMPORT      System_Clock_Init
IMPORT      UART2_Init
IMPORT      USART2_Write

      AREA    main, CODE, READONLY

      EXPORT      __main                        ; make __main visible to linker

      ENTRY            

                       

__main      PROC

               LDR r0, =RCC_BASE    ; Configuring the reset and clock of the microcontroller
               LDR r1, [r0, #RCC_AHB2ENR] ; Loading the value of the clock onto r1
               BIC r1, #0x6 ; Masking the GPIOB and GPIOC to enable the clock
               ORR r1, #0x6 ; Setting the desired GPIOs (GPIOB and GPIOC)
               STR r1, [r0, #RCC_AHB2ENR] ; Storing the value of the clock to r1

     
               LDR r0, =GPIOB_BASE    ; Configuring the MODER resgisters in GPIOB
               LDR r4, [r0, #GPIO_MODER] ; Loading the value of the MODER onto r4
               BIC r4, #0xF ; Masking the registers that we are interested in 
               BIC r4, #0xF0 ; Masking the registers that we are interested in 
               ORR r4, #0x5 ; Setting the desired resgisters
               ORR r4, #0x50 ; Setting the desired resgisters
               STR r4, [r0, #GPIO_MODER] ; Storing the value of the MODER to r4


               LDR r0, =GPIOC_BASE    ; Configuring the MODER resgisters in GPIOC
               LDR r2, [r0, #GPIO_MODER] ; Loading the value of the MODER onto r2
               BIC r2, #0x0F000000 ; Masking the registers that we are interested in 
               ORR r2, #0x00 ; Setting the desired resgisters
               STR r2, [r0, #GPIO_MODER] ; Storing the value of the MODER to r2


               AND r3, #0x0 ; Initialzing the register 3 to 0
               ORR r3, #0x0 ; Initialzing the register 3 to 0

 ; While loop to go through numbers 0-9 forever
while1

                    LDR r10, =GPIOC_BASE  ; Configuring r10 to GPIOC Base
                    LDR r11, [r10, #GPIO_IDR]   ; Loading the input data into the r11
                    TST r11, #0x00002000  ; Testing the number inputted in r11 to if the 13th bit is set or not
                    BNE machi_cout  ; If they are not equal, then the counter just keeps going 
                    MOV r3, #0      ; Resetting the number if input is pressed

; Subroutine to display the numbers and delay the number     
machi_cout

                    MOV R5, #0xA ; Moving 10 to register 5
                    SUBS r9,r5,r3   ; Subtracting the register 3 from the register 5 value
                    BEQ reset ; Going into the reset subroutine when the statement above is true
                    LDR r0, =GPIOB_BASE  ; Configuring r10 to GPIOB Base
                    LDR r7, [r0, #GPIO_ODR]   ; Loading the input data into the r7
                    BIC r7, #0xF ; Masking the registers that we are interested in 
                    MOV r7, r3 ; Displaying the value to the 7-segment display by moving r3 value to r7
                    STR r7, [r0, #GPIO_ODR]  ; Storing the value of the MODER to r7    
                    BL add_one      ; Calling the increment to add one to the number

                    MOV r5, #0xFFFF ; Moving the maximum value into register 5
                    BL delay  ; Calling the delay function until the value above is 0 to create a delay
                    MOV r5, #0xFFFF ; Moving the maximum value into register 5
                    BL delay  ; Calling the delay function until the value above is 0 to create a delay
                    MOV r5, #0xFFFF ; Moving the maximum value into register 5
                    BL delay  ; Calling the delay function until the value above is 0 to create a delay
                    MOV r5, #0xFFFF ; Moving the maximum value into register 5
                    BL delay  ; Calling the delay function until the value above is 0 to create a delay
                    MOV r5, #0xFFFF ; Moving the maximum value into register 5
                    BL delay  ; Calling the delay function until the value above is 0 to create a delay
                    MOV r5, #0xFFFF ; Moving the maximum value into register 5
                    BL delay  ; Calling the delay function until the value above is 0 to create a delay

            BL while1 ; Infinitely calling the while loop to never stop

; Delay Subrountine
delay    
            SUBS r5, r5, #1   ; Subtracting 1 every time of the loop to create a delay
            BNE delay   ; Recursively the delay function until it reaches 0
            BX LR ; Branches the Link Register to the next instrucition in the main

; Subroutine that resets the counter after it reaches 9
reset
            AND r3, #0x00000000 ; Resetting the value displayed in the 7-segment display
            B while1 ; Branching back to the 'while' subroutine

; Subroutine that increments the number displayed
add_one
            ADD r3, r3, #0x1   ; Incrementing the number displaying until it reaches 9
            BX LR ; Branches the Link Register to the next instrucition in the main

stop  B           stop              ; dead loop & program hangs here

      ENDP
