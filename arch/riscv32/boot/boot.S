#include "platform.h"

# Each hart's stack size: 1024 bytes
.equ		STACK_SIZE, 1024

.global		_start

.text
.balign 4
_start:
	csrr	t0, mhartid
	mv      tp, t0
	bnez	t0, sleep			# if not hart 0, to sleep (we only use hart 0)

	# Clear BSS section.
	la	    a0, _bss_start
	la	    a1, _bss_end
	bgeu	a0, a1, 2f
1:

	sw	    zero, (a0)
	addi	a0, a0, 4
	bltu	a0, a1, 1b
2:

	# Setup stack.
	slli	t0, t0, 10
	la		sp, stacks + STACK_SIZE # sp = stacks + 1024
	add		sp, sp, t0			    # sp = stacks + 1024 + 0

	# Jump to C environment.
	j		start_kernel

# Sleep (low power)
sleep:
	wfi
	j		sleep

# Stack for hart 0 ~ 7
.balign 16
stacks:
	.space	STACK_SIZE * MAXNUM_CPU

.end
