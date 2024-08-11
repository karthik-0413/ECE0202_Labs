#include "stm32l476xx.h"
#include "I2C.h"
#include "ssd1306.h"

#include <string.h>
#include <stdio.h>

void System_Clock_Init(void);
void RTC_Clock_Init(void);
void RTC_Init(void);
void I2C_GPIO_init(void);
void DisplayString(char* messge);
char date[] = "123456";


void DisplayString(char* message)
{

    ssd1306_Fill(White);
    ssd1306_SetCursor(2,0);
    ssd1306_WriteString(message, Font_11x18, Black);
    ssd1306_UpdateScreen();

}

// Declaring needed variables for the SysTick_Handler
char message[9] = "13:59:30";    // Variable to initial the clock
int p = 0;    // Variable to help increment time

void SysTick_Handler(void)
{
    
    // Converting each part of the time into a character and putting it in the message char array
    message[0]=(((RTC->TR)>>20) & 0x0F) + '0';  // Converting the Hours Tens to char
    message[1]=(((RTC->TR)>>16) & 0x0F) + '0';  // Converting the Hours Units to char
    message[3]=(((RTC->TR)>>12) & 0x0F) + '0';  // Converting the Minutes Tens to char
    message[4]=(((RTC->TR)>>8) & 0x0F) + '0';  // Converting the Minutes Units to char
    message[6]=(((RTC->TR)>>4) & 0x0F) + '0';  // Converting the Seconds Tens to char
    message[7]=(((RTC->TR)) & 0x0F) + '0';  // Converting the Seconds Units to char

    // If-Statement to make sure that the time changes only if the second has changed
    if (p != message[7])
    {
        // Using the given display function to display the time to the OLED
        DisplayString(message);

        // Setting the checker variable to the new seconds number
        p = message[7];
    }
}

int main(void)
{
    // Enable High Speed Internal Clock (HSI = 16 MHz)
    RCC->CR |= ((uint32_t)RCC_CR_HSION);

    // wait until HSI is ready
    while ( (RCC->CR & (uint32_t) RCC_CR_HSIRDY) == 0 ) {;}

    // Select HSI as system clock source
    RCC->CFGR &= (uint32_t)((uint32_t)~(RCC_CFGR_SW));
    RCC->CFGR |= (uint32_t)RCC_CFGR_SW_HSI;  //01: HSI16 oscillator used as system clock

    // Wait till HSI is used as system clock source
    while ((RCC->CFGR & (uint32_t)RCC_CFGR_SWS) == 0 ) {;}

    NVIC_SetPriority(SysTick_IRQn, 1);        // Set Priority to 1
    NVIC_EnableIRQ(SysTick_IRQn);                         // Enable EXTI0_1 interrupt in NVIC

    // Calling a few deep-level system configuration functions 
    // in order to start and configure the clocks
    // and power distribution for the system
    System_Clock_Init();
    I2C_GPIO_init();
    I2C_Initialization(I2C1);
    ssd1306_Init();
    RTC_Clock_Init();

    // ***********************
    // RTC Configuration *
    // ***********************

    // Disabling the RTC registers write protection
    RTC->WPR = 0xCA;    // Write 0xCA into the WPR register
    RTC->WPR = 0x53;    // and then write 0x53 into the WPR register

    // Entering initialization mode
    RTC->ISR |= (1U << 7); // Set all bits of the ISR register

    // Waiting for the confirmation of initialization mode (clock synchronizatoin)
    while( (RTC->ISR & 0x40) != 0x40) {;}    // Polling the INITF bit until it is set

    // Load the time values into the shadow registers
    RTC->TR = 0x135930; // Initial Time Given = 13:59:30

    // Exiting initialization mode
    RTC->ISR &= ~(1U << 7); // Clear the INIT bit of the ISR register

    // Enabling the RTC registers write protection
    RTC->WPR = 0xFF;    // Write 0xFF into the WPR register

    // ***********************
    // SysTick Configuration *
    // ***********************

    // Disabling the SysTick IRQ by clearing the Tickint bit in the CTRL register
    SysTick->CTRL = 0;

    // Set the SysTick reload value register (LOAD
    SysTick->LOAD = 79999;

    // Reset the SysTick counter value register (VAL) by writing a value of 0 to it
    SysTick->VAL = 0;

    // Setting the first three bits (enabling TICKINT, ENABLE, and CLKSOURCE) in the SysTick->CTR register
    SysTick->CTRL |= 0x7;

    // Dead loop & program hangs here
    while(1){}
}