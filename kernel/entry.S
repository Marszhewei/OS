# In context switching, we need to save and restore:
# ra sp s0~s11

# Save context(registers).
.macro reg_save base
	# sd zero, 0 * 8(\base)   # zero
	sd ra,   1 * 8(\base)   # return address
	sd sp,   2 * 8(\base)   # stack pointer
	# sd gp,   3 * 8(\base)   # global pointer
	# sd tp,   4 * 8(\base)   # thread pointer
	# sd t0,   5 * 8(\base)   # temporary register 0
	# sd t1,   6 * 8(\base)   # temporary register 1
	# sd t2,   7 * 8(\base)   # temporary register 2
	sd s0,   8 * 8(\base)   # saved register 0 (frame pointer)
	sd s1,   9 * 8(\base)   # saved register 1
	# sd a0,  10 * 8(\base)   # argument register 0
	# sd a1,  11 * 8(\base)   # argument register 1
	# sd a2,  12 * 8(\base)   # argument register 2
	# sd a3,  13 * 8(\base)   # argument register 3
	# sd a4,  14 * 8(\base)   # argument register 4
	# sd a5,  15 * 8(\base)   # argument register 5
	# sd a6,  16 * 8(\base)   # argument register 6
	# sd a7,  17 * 8(\base)   # argument register 7
	sd s2,  18 * 8(\base)   # saved register 2
	sd s3,  19 * 8(\base)   # saved register 3
	sd s4,  20 * 8(\base)   # saved register 4
	sd s5,  21 * 8(\base)   # saved register 5
	sd s6,  22 * 8(\base)   # saved register 6
	sd s7,  23 * 8(\base)   # saved register 7
	sd s8,  24 * 8(\base)   # saved register 8
	sd s9,  25 * 8(\base)   # saved register 9
	sd s10, 26 * 8(\base)   # saved register 10
	sd s11, 27 * 8(\base)   # saved register 11
	# sd t3,  28 * 8(\base)   # temporary register 3
	# sd t4,  29 * 8(\base)   # temporary register 4
	# sd t5,  30 * 8(\base)   # temporary register 5
	# sd t6,  31 * 8(\base)   # temporary register 6
.endm

# Restore context(registers).
.macro reg_restore base
	# ld zero, 0 * 8(\base)   # zero
	ld ra,   1 * 8(\base)   # return address
	ld sp,   2 * 8(\base)   # stack pointer
	# ld gp,   3 * 8(\base)   # global pointer
	# ld tp,   4 * 8(\base)   # thread pointer
	# ld t0,   5 * 8(\base)   # temporary register 0
	# ld t1,   6 * 8(\base)   # temporary register 1
	# ld t2,   7 * 8(\base)   # temporary register 2
	ld s0,   8 * 8(\base)   # saved register 0 (frame pointer)
	ld s1,   9 * 8(\base)   # saved register 1
	# ld a0,  10 * 8(\base)   # argument register 0
	# ld a1,  11 * 8(\base)   # argument register 1
	# ld a2,  12 * 8(\base)   # argument register 2
	# ld a3,  13 * 8(\base)   # argument register 3
	# ld a4,  14 * 8(\base)   # argument register 4
	# ld a5,  15 * 8(\base)   # argument register 5	
	# ld a6,  16 * 8(\base)   # argument register 6
	# ld a7,  17 * 8(\base)   # argument register 7
	ld s2,  18 * 8(\base)   # saved register 2
	ld s3,  19 * 8(\base)   # saved register 3
	ld s4,  20 * 8(\base)   # saved register 4
	ld s5,  21 * 8(\base)   # saved register 5
	ld s6,  22 * 8(\base)   # saved register 6
	ld s7,  23 * 8(\base)   # saved register 7
	ld s8,  24 * 8(\base)   # saved register 8
	ld s9,  25 * 8(\base)   # saved register 9
	ld s10, 26 * 8(\base)   # saved register 10
	ld s11, 27 * 8(\base)   # saved register 11
	# ld t3,  28 * 8(\base)   # temporary register 3
	# ld t4,  29 * 8(\base)   # temporary register 4
	# ld t5,  30 * 8(\base)   # temporary register 5
	# ld t6,  31 * 8(\base)   # temporary register 6
.endm


.text

.globl trap_vector
.balign 8
trap_vector:
	# save context(registers).
	csrrw	t6, mscratch, t6	# swap t6 and mscratch
	reg_save t6

	# Save the actual t6 register, which we swapped into
	# mscratch
	mv	t5, t6			# t5 points to the context of current task
	csrr	t6, mscratch		# read t6 back from mscratch
	sd	t6, 30 * 8(t5)	# save t6 with t5 as base

	# Restore the context pointer into mscratch
	csrw	mscratch, t5

	# call the C trap handler in trap.c
	csrr	a0, mepc
	csrr	a1, mcause
	call	trap_handler

	# trap_handler will return the return address via a0.
	csrw	mepc, a0

	# restore context(registers).
	csrr	t6, mscratch
	reg_restore t6

	# return to whatever we were doing before trap.
	mret


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
