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
.balign 4
trap_vector:
	csrr	    t0, mscratch
	reg_save    t0

	csrr	    a0, mepc
	csrr	    a1, mcause
	call	    trap_handler

	csrw	    mepc, a0

	csrr	    t0, mscratch
	reg_restore t0

	mret


.globl switch_to
.balign 4
switch_to:
	csrr	    t0, mscratch
	beqz	    t0, 1f

	reg_save    t0

1:
	csrw	    mscratch, a0

	reg_restore a0

	ret

.end
