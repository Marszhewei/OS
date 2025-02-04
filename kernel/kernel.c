#include "kernel.h"
#include "junkv/sched.h"


void start_kernel(void)
{
	uart_init();
	uart_puts("UART init done!\n");

	printf("Hello, Junkv-OS!\n");

	// char name[32];
	// uart_gets(name);
	// printf("Your input is: %s\n", name);

	page_init();

	sched_init();
	schedule();
	schedule();

	uart_puts("Would not go here!\n");

	// go idle
	while (1) {};
}
