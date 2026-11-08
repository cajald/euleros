#!/bin/sh
#
# emul.sh -- QEMU x86_64 emulation
#

IMG=build/argon.img
LOG=build/qemu.log

QEMU=qemu-system-x86_64

if ! [ -f "$IMG" ]; then
    echo "Disk image is missing. Run disk.rc first"
    exit 1
fi

if ! command -v "$QEMU" >/dev/null 2>&1; then
    echo "QEMU not found: $QEMU"
    echo "Install qemu-system-x86"
    exit 1
fi

mkdir -p build

echo '==> Starting QEMU'

exec "$QEMU" \
    -machine pc \
    -cpu qemu64 \
    -m 64M \
    -drive file="$IMG",format=raw,if=ide,index=0 \
    -boot order=c \
    -vga std \
    -rtc clock=host \
    -serial stdio \
    -no-reboot \
    -no-shutdown \
    -D "$LOG"

