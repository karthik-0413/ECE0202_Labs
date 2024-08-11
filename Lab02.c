#include "stm32l476xx.h"
#include "SysClock.h"
#include "UART.h"
#include <string.h>
#include <stdio.h>
#include <stdbool.h>

// PA.5 <--> Green LED
// PC.13 <--> Blue user button
#define LED_PIN 5
#define BUTTON_PIN 13

void demo_of_printf_scanf() {
    char rxByte;
    printf("Are you enrolled in ECE 202 (Y or N ):\r\n");
    scanf("%c", &rxByte);
    if (rxByte == 'N' || rxByte == 'n') {
        printf("You should not be here!!!\r\n\r\n");
    } else if (rxByte == 'Y' || rxByte == 'y') {
        printf("Welcome!!! \n\r\n\r\n");
    }
}

int main(void) {
    System_Clock_Init(); // Switch System Clock = 80 MHz
    UART2_Init(); // Communicate with Tera Term

    // demo_of_printf_scanf();

    // ****************************//
    // USER CODE GOES HERE
    // ****************************//

    // Configure Clock (Step 1)
    RCC->AHB2ENR &= ~(0x00000005); // Clear bits
    RCC->AHB2ENR |= 0x00000005; // Set Clock to target value

    // Configure PA5
    GPIOA->MODER &= ~0x00000C00; // Clear bit 10 and bit 11
    GPIOA->MODER |= 0x00000400; // Set MODER5 to output
    GPIOA->OTYPER &= ~0x00000020; // Clear bit 5
    GPIOA->OTYPER |= 0x00000000; // Set output type to Push-Pull
    GPIOA->PUPDR &= ~0x00000C00; // Clear bits 10 and 11
    GPIOA->PUPDR |= 0x00000000; // Set Push-Pull type to no pullup, no pulldown

    // Configure PC13
    GPIOC->MODER &= ~(0x0C000000); // Clear bits 26 and 27
    GPIOC->MODER |= (0x00000000); // Set bits to GPIO Input
    GPIOC->PUPDR &= ~(0x0C000000); // Mask bits 26 and 27
    GPIOC->PUPDR |= (0x00000000); // Set bits to no pullup, no pulldown

    GPIOA->ODR &= ~(0x00000020); // Mask bit 5
    GPIOA->ODR |= (0x00000020); // Initially turn bit on

    // Configure LED to toggle between on and off when button is pressed each time
    bool change; // Variable to know which state the LED is to be toggled to
    int status; // Variable to keep track of the bit that is being 'studied'
    int button; // Variable to keep track of if the button was pressed or not

    for (;;) { // Infinite loop determines state of LED
        status = GPIOC->IDR & (1UL << 13); // Setting status variable to the input of the IDR register
        if (!status) { // See if the bit initialized above is 0
            if (!button) { // See if the button was not pressed
                change = !change; // Toggle the change variable to indicate if the LED will turn on or off
                button = 1; // Setting button to 1 so that the code does not enter this loop again next time
            }
        } else {
            button = 0; // Setting button to 0 so that the code enters the code above next time
        }
        if (change) { // Mask to bit 13 check if there is input from IDR, (not gate because IDR active low)
            GPIOA->ODR |= (0x00000020); // Set bit 5 to on (turn LED on)
        } else {
            GPIOA->ODR &= ~(0x00000020); // Clear bit 5 (turn LED off)
        }
    }
}
