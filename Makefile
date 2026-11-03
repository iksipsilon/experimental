# experimental for RV32EC / CH32V006

CROSS   ?= riscv64-unknown-elf-
AS      := $(CROSS)as
LD      := $(CROSS)ld
OBJCOPY := $(CROSS)objcopy
OBJDUMP := $(CROSS)objdump

ARCH    := rv32ec_zicsr_zmmul
DEVICE  ?= /dev/ttyACM0

all: experimental.bin
build: experimental.bin

experimental.o: experimental.s # other-files.s otherfiles.f
	$(AS) -g -march=$(ARCH) -mno-relax -I. -o $@ experimental.s

experimental.elf: experimental.o linker.ld
	$(LD) -m elf32lriscv -T linker.ld -o $@ $<

experimental.bin: experimental.elf
	$(OBJCOPY) -O binary $< $@

dump: experimental.elf
	$(OBJDUMP) -D $< > experimental.dump

test: experimental.bin
	python3 tools/test.py

flash: experimental.bin
	minichlink -w experimental.bin flash -b

term:
	picocom -b 115200 --omap crcrlf --imap lfcrlf $(DEVICE)

clean:
	rm -f experimental.o experimental.elf experimental.bin experimental.dump

.PHONY: all build dump test flash term clean
