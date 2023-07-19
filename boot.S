#include "platform.h"

# size of each hart's stack is 1024 bytes
.equ		STACK_SIZE, 1024

.global		_start

.text
_start:
	csrr	t0, mhartid			# hart 0
	bnez	t0, sleep			# if not hart 0, to sleep

	# setup stack
	slli	t0, t0, 10
	la		sp, stacks + STACK_SIZE
	add		sp, sp, t0

	j		start_kernel		# start kernel

sleep:
	wfi							# sleep (low power consumption)
	j	sleep

stacks:
	.skip	STACK_SIZE * MAXNUM_CPU
