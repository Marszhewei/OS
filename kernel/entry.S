.macro reg_save base
	sw ra,   0 * 8(\base)
	sw sp,   1 * 8(\base)
	sw t0,   4 * 8(\base)
	sw t1,   5 * 8(\base)
	sw t2,   6 * 8(\base)
	sw s0,   7 * 8(\base)
	sw s1,   8 * 8(\base)
	sw a0,   9 * 8(\base)
	sw a1,  10 * 8(\base)
	sw a2,  11 * 8(\base)
	sw a3,  12 * 8(\base)
	sw a4,  13 * 8(\base)
	sw a5,  14 * 8(\base)
	sw a6,  15 * 8(\base)
	sw a7,  16 * 8(\base)
	sw s2,  17 * 8(\base)
	sw s3,  18 * 8(\base)
	sw s4,  19 * 8(\base)
	sw s5,  20 * 8(\base)
	sw s6,  21 * 8(\base)
	sw s7,  22 * 8(\base)
	sw s8,  23 * 8(\base)
	sw s9,  24 * 8(\base)
	sw s10, 25 * 8(\base)
	sw s11, 26 * 8(\base)
	sw t3,  27 * 8(\base)
	sw t4,  28 * 8(\base)
	sw t5,  29 * 8(\base)
.endm

.macro reg_restore base
	lw ra,   0 * 8(\base)
	lw sp,   1 * 8(\base)
	lw t0,   4 * 8(\base)
	lw t1,   5 * 8(\base)
	lw t2,   6 * 8(\base)
	lw s0,   7 * 8(\base)
	lw s1,   8 * 8(\base)
	lw a0,   9 * 8(\base)
	lw a1,  10 * 8(\base)
	lw a2,  11 * 8(\base)
	lw a3,  12 * 8(\base)
	lw a4,  13 * 8(\base)
	lw a5,  14 * 8(\base)
	lw a6,  15 * 8(\base)
	lw a7,  16 * 8(\base)
	lw s2,  17 * 8(\base)
	lw s3,  18 * 8(\base)
	lw s4,  19 * 8(\base)
	lw s5,  20 * 8(\base)
	lw s6,  21 * 8(\base)
	lw s7,  22 * 8(\base)
	lw s8,  23 * 8(\base)
	lw s9,  24 * 8(\base)
	lw s10, 25 * 8(\base)
	lw s11, 26 * 8(\base)
	lw t3,  27 * 8(\base)
	lw t4,  28 * 8(\base)
	lw t5,  29 * 8(\base)
	lw t6,  30 * 8(\base)
.endm

.text
.globl switch_to
.balign 4
switch_to:
	csrrw	    t6, mscratch, t6	# swap t6 and mscratch
	beqz	    t6, switch_to_next	# Note: the first time switch_to() is
	                                # called, mscratch is initialized as zero
					# (in sched_init()), which makes t6 zero,
					# and that's the special case we have to
					# handle with t6
	reg_save    t6			# save context of prev task

	# Save the actual t6 register, which we swapped into
	# mscratch
	mv	        t5, t6			# t5 points to the context of current task
	csrr	    t6, mscratch		# read t6 back from mscratch
	sw	        t6, 30 * 8(t5)	# save t6 with t5 as base

switch_to_next:
	csrw	    mscratch, a0

	mv	        t6, a0
	reg_restore t6

	ret

.end
