#include "kernel.h"


void start_kernel(void)
{
	uart_init();
	uart_puts("UART init done!\n");

	printf("Hello, Junkv-OS!\n");

	page_init();

	// go idle
	while (1) {};
}
