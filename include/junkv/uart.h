#ifndef __JUNKV_UART_H_
#define __JUNKV_UART_H_

extern void uart_putc(char c);

extern void uart_puts(char *s);

extern char uart_getc(void);

extern void uart_gets(char *s);

#endif /* __JUNKV_UART_H_ */
