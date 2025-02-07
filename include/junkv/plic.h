#ifndef __JUNKV_PLIC_H__
#define __JUNKV_PLIC_H__

extern int plic_claim(void);

extern void plic_complete(int irq);

#endif /* __JUNKV_PLIC_H__ */
