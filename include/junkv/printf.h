#ifndef __JUNKV_PRINTF_H_
#define __JUNKV_PRINTF_H_

#include <stddef.h>
#include <stdarg.h>

#include "uart.h"

extern int  printf(const char* s, ...);
extern void panic(char *s);

#endif /* __JUNKV_PRINTF_H_ */
