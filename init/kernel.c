#include <junkv/printf.h>
#include <junkv/sched.h>

extern void uart_init(void);
extern void page_init(void);
extern void trap_init(void);
extern void plic_init(void);
extern void sched_init(void);

extern void user_main(void);

void start_kernel(void)
{
	uart_init();
	printf("Hello, Junkv-OS!\n");

	// page_init();
	trap_init();
	plic_init();
	sched_init();

	user_main();

	schedule();

	// go idle
	while (1) {};
}
