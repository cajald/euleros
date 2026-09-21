#
# Makefile -- kernel build system
#

### data ###

.SUFFIXES: .asm .o .c

FASM ?= fasm
TCC  ?= tcc

ELF = euclid64.elf

CFLAGS   = -m64 -ffreestanding -fno-stack-protector -fno-pic -fno-pie -nostdlib \
	   -Wall -Wextra
ASFLAGS ?=
LDFLAGS  = -m64 -nostdlib \
	-Wl,-Ttext,0x00100000 \
	-Wl,-section-alignment=0x1000

CFILES   = kernel.c
ASMFILES = entry.asm

OBJS = ${CFILES:.c=.o} ${ASMFILES:.asm=.o}

### targets ###

${BUILD}:
	mkdir -p ${BUILD}

.c.o:
	${TCC} ${CFLAGS} -c ${.IMPSRC} -o ${.TARGET}

.asm.o:
	${FASM} ${.IMPSRC} ${.TARGET}

${ELF}: ${OBJS}
	@mkdir -p ${.TARGET:H}
	${TCC} ${LDFLAGS} ${OBJS} -o ${.TARGET}

### utils ###

all: ${ELF}
distclean:
	rm -f ${OBJS}

clean: distclean
	rm -f ${ELF}

rebuild: clean all

.PHONY: all distclean clean rebuild

