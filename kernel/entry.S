.macro reg_save base
	sd ra,   0 * 8(\base)
	sd sp,   1 * 8(\base)
	sd t0,   4 * 8(\base)
	sd t1,   5 * 8(\base)
	sd t2,   6 * 8(\base)
	sd s0,   7 * 8(\base)
	sd s1,   8 * 8(\base)
	sd a0,   9 * 8(\base)
	sd a1,  10 * 8(\base)
	sd a2,  11 * 8(\base)
	sd a3,  12 * 8(\base)
	sd a4,  13 * 8(\base)
	sd a5,  14 * 8(\base)
	sd a6,  15 * 8(\base)
	sd a7,  16 * 8(\base)
	sd s2,  17 * 8(\base)
	sd s3,  18 * 8(\base)
	sd s4,  19 * 8(\base)
	sd s5,  20 * 8(\base)
	sd s6,  21 * 8(\base)
	sd s7,  22 * 8(\base)
	sd s8,  23 * 8(\base)
	sd s9,  24 * 8(\base)
	sd s10, 25 * 8(\base)
	sd s11, 26 * 8(\base)
	sd t3,  27 * 8(\base)
	sd t4,  28 * 8(\base)
	sd t5,  29 * 8(\base)
.endm

.macro reg_restore base
	ld ra,   0 * 8(\base)
	ld sp,   1 * 8(\base)
	ld t0,   4 * 8(\base)
	ld t1,   5 * 8(\base)
	ld t2,   6 * 8(\base)
	ld s0,   7 * 8(\base)
	ld s1,   8 * 8(\base)
	ld a0,   9 * 8(\base)
	ld a1,  10 * 8(\base)
	ld a2,  11 * 8(\base)
	ld a3,  12 * 8(\base)
	ld a4,  13 * 8(\base)
	ld a5,  14 * 8(\base)
	ld a6,  15 * 8(\base)
	ld a7,  16 * 8(\base)
	ld s2,  17 * 8(\base)
	ld s3,  18 * 8(\base)
	ld s4,  19 * 8(\base)
	ld s5,  20 * 8(\base)
	ld s6,  21 * 8(\base)
	ld s7,  22 * 8(\base)
	ld s8,  23 * 8(\base)
	ld s9,  24 * 8(\base)
	ld s10, 25 * 8(\base)
	ld s11, 26 * 8(\base)
	ld t3,  27 * 8(\base)
	ld t4,  28 * 8(\base)
	ld t5,  29 * 8(\base)
	ld t6,  30 * 8(\base)
.endm

.text
.globl switch_to
.balign 8
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
	sd	        t6, 30 * 8(t5)	# save t6 with t5 as base

switch_to_next:
	csrw	    mscratch, a0

	mv	        t6, a0
	reg_restore t6

	ret

.end
