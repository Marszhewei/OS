#include <junkv/types.h>
#include <riscv/riscv.h>
#include <junkv/printf.h>
#include <junkv/plic.h>
#include <junkv/uart.h>
#include <platform.h>


extern void trap_vector(void);

void trap_init()
{
	w_mtvec((reg_t)trap_vector);
}

void external_interrupt_handler()
{
	int irq = plic_claim();

	if (irq == UART0_IRQ){
      		uart_putc(uart_getc());
			uart_putc('\n');
	} else if (irq) {
		printf("unexpected interrupt irq = %d\n", irq);
	}
	
	if (irq) {
		plic_complete(irq);
	}
}

reg_t trap_handler(reg_t epc, reg_t cause)
{
	reg_t return_pc = epc;
	reg_t cause_code = cause & MCAUSE_MASK_ECODE;
	
	if (cause & MCAUSE_MASK_INTERRUPT) {
		switch (cause_code) {
		case 3:
			printf("software interruption!\n");
			break;
		case 7:
			printf("timer interruption!\n");
			break;
		case 11:
			printf("external interruption!\n");
			external_interrupt_handler();
			break;
		default:
			printf("Unknown async exception! Code = %ld\n", cause_code);
			break;
		}
	} else {
		printf("Sync exceptions! Code = %ld\n", cause_code);
		panic("OOPS! What can I do!");
	}

	return return_pc;
}
