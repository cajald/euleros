#!/bin/sh
#
# disk.sh -- create argonOS BIOS bootable hard disk
#

set -eu

IMG="build/argon.img"
KERN="build/kernel.elf"
CONFIG="limine.conf"

LIMINE="./limine/limine"
LIMINE_SYS="limine/limine-bios.sys"

DISK_SIZE=512M
SECTORS=1048576

PARTITION_START=2048
PARTITION_SECTORS=$((SECTORS - PARTITION_START))
PARTITION_OFFSET=$((PARTITION_START * 512))

PARTITION_BLOCKS=$((PARTITION_SECTORS / 2))

fail() {
    echo "ERROR: $*" >&2
    exit 1
}

echo "==> Building kernel"

cd kern
mk
cd ..

echo "==> Checking tools"

for tool in parted mkfs.fat mmd mcopy mdir dd truncate; do
    command -v "$tool" >/dev/null 2>&1 ||
        fail "Missing tool: $tool"
done

[ -x "$LIMINE" ] || fail "Limine executable not found"

mkdir -p build

for file in "$KERN" "$CONFIG" "$LIMINE_SYS"; do
    [ -f "$file" ] || fail "Missing file: $file"
done

echo "==> Creating 512 MiB disk"

rm -f "$IMG"
truncate -s "$DISK_SIZE" "$IMG"

echo "==> Creating MBR partition table"

parted -s "$IMG" mklabel msdos

echo "==> Creating FAT32 partition"

parted -s "$IMG" \
    mkpart primary fat32 "${PARTITION_START}s" 100%

parted -s "$IMG" set 1 boot on

echo "==> Formatting FAT32"

mkfs.fat -F 32 -s 8 \
    -h "$PARTITION_START" \
    --offset="$PARTITION_START" \
    "$IMG" "$PARTITION_BLOCKS"

# mount partition
VOLUME="${IMG}@@${PARTITION_OFFSET}"

echo "==> Creating boot directory"

mmd -i "$VOLUME" ::/boot

echo "==> Installing kernel"

mcopy -i "$VOLUME" "$KERN" ::/boot/kernel.elf

echo "==> Installing Limine configuration"

mcopy -i "$VOLUME" "$CONFIG" ::/limine.conf

echo "==> Installing Limine BIOS system file"

mcopy -i "$VOLUME" "$LIMINE_SYS" ::/limine-bios.sys

echo "==> Installing Limine BIOS bootloader"

"$LIMINE" bios-install "$IMG"

echo "==> Checking partition table"

parted -s "$IMG" print

echo "==> Checking filesystem"

mdir -i "$VOLUME" ::

echo "==> Checking boot directory"

mdir -i "$VOLUME" ::/boot

echo "==> Disk successfully created: $IMG"

