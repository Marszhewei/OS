CROSS_COMPILE = riscv64-unknown-elf-

QEMU = qemu-system-riscv64
QFLAGS = -nographic -smp 1 -machine virt -bios none -gdb tcp::1234

CC = ${CROSS_COMPILE}gcc
# GDB = ${CROSS_COMPILE}gdb
GDB = gdb-multiarch
OBJCOPY = ${CROSS_COMPILE}objcopy
OBJDUMP = ${CROSS_COMPILE}objdump

BUILD_PATH = build

CFLAGS = -nostdlib -fno-builtin -march=rv64g -mabi=lp64 -g -Wall -I include -mcmodel=medany
LDFLAGS = -T ${BUILD_PATH}/kernel.ld.generated

SRCS_ASM =          \
	arch/riscv64/boot/boot.S     \
	mm/mem.S        \
	kernel/entry.S

SRCS_C =            \
	init/kernel.c \
	mm/page.c       \
	drivers/serial/uart.c   \
	kernel/printf.c \
	kernel/sched.c  \
	kernel/trap.c   \
	kernel/plic.c \
	user/main.c

vpath %.c kernel lib mm user drivers/serial init
vpath %.S boot mm kernel arch/riscv64/boot

OBJS_ASM = $(addprefix ${BUILD_PATH}/, $(notdir $(patsubst %.S, %.o, ${SRCS_ASM})))
OBJS_C   = $(addprefix ${BUILD_PATH}/, $(notdir $(patsubst %.c, %.o, ${SRCS_C})))
OBJS = ${OBJS_ASM} ${OBJS_C}

ELF = ${BUILD_PATH}/junkv.elf
BIN = ${BUILD_PATH}/junkv.bin

.DEFAULT_GOAL := all
all: ${BUILD_PATH} ${ELF}

${BUILD_PATH}:
	@mkdir -p $@

${ELF}: ${OBJS}
	${CC} -E -P -x c ${DEFS} ${CFLAGS} kernel.ld > ${BUILD_PATH}/kernel.ld.generated
	${CC} ${CFLAGS} ${LDFLAGS} -o ${ELF} $^
	${OBJCOPY} -O binary ${ELF} ${BIN}

${BUILD_PATH}/%.o: %.c
	${CC} ${CFLAGS} -c -o $@ $<

${BUILD_PATH}/%.o: %.S
	${CC} ${CFLAGS} -c -o $@ $<

.PHONY : run
run: all
	@${QEMU} -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	@echo "------------------------------------"
	@${QEMU} ${QFLAGS} -kernel ${ELF}

.PHONY : debug
debug: all
	@${QEMU} -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	@echo "------------------------------------"
	@${QEMU} ${QFLAGS} -kernel ${ELF} -S

.PHONY : gdb
gdb: all
	@echo "Press Ctrl-C and then input 'quit' to exit GDB"
	@echo "-------------------------------------------------------"
	@${GDB} ${ELF} -q -x gdbinit

.PHONY : code
code: all
	@${OBJDUMP} -S ${ELF} | less

.PHONY : clean
clean:
	rm -rf ${BUILD_PATH}

