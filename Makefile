QEMU = qemu-system-riscv32
QFLAGS = -nographic -smp 1 -machine virt -bios none

CC = riscv32-unknown-elf-gcc
CFLAGS = -nostdlib -fno-builtin -march=rv32ima -mabi=ilp32 -g -Wall

# just for qemu virt
DRAM_START_ADDRESS = 0x80000000

SRCS_ASM = boot.S
SRCS_C = kernel.c

OBJS = $(SRCS_ASM:.S=.o)
OBJS += $(SRCS_C:.c=.o)

all: os.elf

os.elf: ${OBJS}
	${CC} ${CFLAGS} -Ttext=${DRAM_START_ADDRESS} -o os.elf $^

%.o: %.c
	${CC} ${CFLAGS} -c -o $@ $<

%.o: %.S
	${CC} ${CFLAGS} -c -o $@ $<

run: all
	@${QEMU} -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	@echo "------------------------------------"
	@${QEMU} ${QFLAGS} -kernel os.elf

.PHONY : clean
clean:
	rm -rf *.o *.elf

