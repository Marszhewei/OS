#ifndef __JUNKV_SCHED_H_
#define __JUNKV_SCHED_H_

extern int  task_create(void (*task)(void));
extern void task_delay(volatile int count);
extern void task_yield();

extern void sched_init(void);
extern void schedule(void);

#endif /* __JUNKV_SCHED_H_ */
