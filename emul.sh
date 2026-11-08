#!/bin/sh
#
# emul.sh -- emulation
#

IMG=build/argon.img
CONFIG=build/bochsrc

BIOS=/usr/share/bochs/BIOS-bochs-latest
VGA=/usr/share/bochs/vgabios-cirrus.bin-1.13.0

if ! [ -f $IMG ]; then
	echo Disk image is missing. Run disk.rc first
	exit 1
fi

if ! [ -f $BIOS ]; then
	echo Bochs bios not found: $BIOS
	echo Change bios in emul.sh to match your install
	exit 1
fi

if ! [ -f $VGA ]; then
	echo Bochs vga bios not found: $VGA
	echo Change vga in emul.sh to match your install
	exit 1
fi

echo '==> Generating bochs config'

mkdir -p build
cat > $CONFIG <<EOF
megs: 64
romimage: file=$BIOS
vgaromimage: file=$VGA

boot: floppy
floppya: 2_88=$IMG, status=inserted
log: build/bochs.log
clock: sync=realtime
mouse: enabled=1
panic: action=ask
error: action=report
info: action=ignore
debug: action=ignore
EOF

echo '==> Starting bochs'

bochs -q -f $CONFIG

