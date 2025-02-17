#include <junkv/printf.h>
#include <junkv/sched.h>
#include <junkv/trap.h>

#define DELAY 1000

void user_task0(void)
{
	printf("Task 0: Created!\n");
	while (1) {
		printf("Task 0: Running...\n");

		// Just for testing trap
		// trap_test();

		task_delay(DELAY);
		task_yield();
	}
}

void user_task1(void)
{
	printf("Task 1: Created!\n");
	while (1) {
		printf("Task 1: Running...\n");
		task_delay(DELAY);
		task_yield();
	}
}

/* NOTICE: DON'T LOOP INFINITELY IN main() */
void user_main(void)
{
	task_create(user_task0);
	task_create(user_task1);
}
