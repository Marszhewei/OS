#ifndef __JUNKV_TRAP_H_
#define __JUNKV_TRAP_H_

#include <junkv/types.h>

reg_t trap_handler(reg_t epc, reg_t cause);

#endif /* __JUNKV_TRAP_H_ */
