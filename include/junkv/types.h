#ifndef __JUNKV_TYPES_H_
#define __JUNKV_TYPES_H_

typedef unsigned char          uint8_t;
typedef signed short int       int16_t;
typedef unsigned short int     uint16_t; 
typedef signed int             int32_t;
typedef unsigned int           uint32_t;
typedef signed long long int   int64_t;
typedef unsigned long long int uint64_t;

typedef uint64_t           ptr_t;
typedef uint64_t           reg_t;

typedef long unsigned int  size_t;

#define NULL ((void*)0)

typedef __builtin_va_list va_list;
#define va_start(ap, param) __builtin_va_start(ap, param)
#define va_end(ap) __builtin_va_end(ap)
#define va_arg(ap, type) __builtin_va_arg(ap, type)

#endif /* __JUNKV_TYPES_H_ */
