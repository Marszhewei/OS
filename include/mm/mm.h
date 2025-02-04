#ifndef __MM_MM_H_
#define __MM_MM_H_

extern void page_init(void);
extern void *page_alloc(int npages);
extern void page_free(void *p);

#endif /* __MM_MM_H_ */
