#include "kernel.h"


void start_kernel(void)
{
	uart_init();
	uart_puts("UART init done!\n");

	printf("Hello, Junkv-OS!\n");

	char name[32];
	uart_gets(name);
	printf("Your input is: %s\n", name);

	page_init();

	// go idle
	while (1) {};
}
