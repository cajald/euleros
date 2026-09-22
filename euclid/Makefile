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
VERSION  = "euclid-0.1.0/dev"
CPPFLAGS = -DVERSION=\""${VERSION}"\" -Iinclude/ -I3rdparty/
ASFLAGS ?=
LDFLAGS  = -m64 -nostdlib \
	-Wl,-Ttext,0x00100000 \
	-Wl,-section-alignment=0x1000

CFILES   = kernel.c drivers/serial.c lib/tcc.c lib/string.c
ASMFILES = entry.asm util.asm panic.asm

OBJS = ${CFILES:.c=.o} ${ASMFILES:.asm=.o}

### targets ###

${BUILD}:
	mkdir -p ${BUILD}

.c.o:
	${TCC} ${CFLAGS} ${CPPFLAGS} -MMD -MF ${.IMPSRC:.c=.d} -c ${.IMPSRC} -o ${.TARGET}

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

-include ${CFILES:.c=.d}

