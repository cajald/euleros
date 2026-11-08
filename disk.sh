#!/bin/sh
#
# disk.sh -- create Limine BIOS bootable 2.88 MB floppy
#

set -eu

IMG=build/argon.img
KERN=build/kernel.elf
CONFIG=limine.conf
LIMINE_SYS=limine/limine-bios.sys
LIMINE=./limine/limine

# Disk geometry
SECTORS=5760
SECTOR_SIZE=512

# MBR partition geometry
PARTITION_START=63
PARTITION_END=$((SECTORS - 1))

PARTITION_SECTORS=$((PARTITION_END - PARTITION_START + 1))
PARTITION_OFFSET=$((PARTITION_START * SECTOR_SIZE))

# mkfs.fat BLOCKS are measured in 1024-byte units.
PARTITION_BLOCKS=$((PARTITION_SECTORS * SECTOR_SIZE / 1024))

fail() {
    echo "ERROR: $*" >&2
    exit 1
}

echo "==> Checking tools"

for tool in parted mmd mcopy mdir mkfs.fat dd truncate; do
    command -v "$tool" >/dev/null 2>&1 ||
        fail "Missing tool: $tool"
done

[ -x "$LIMINE" ] || fail "Limine executable not found"

mkdir -p build

# Build kernel if necessary
if [ ! -f "$KERN" ]; then
    echo "==> Building kernel"

    command -v mk >/dev/null 2>&1 ||
        fail "Missing kernel build tool: mk"

    (cd kern && mk) || fail "Kernel build failed"
fi

# Check required inputs
for file in "$KERN" "$CONFIG" "$LIMINE_SYS"; do
    [ -f "$file" ] || fail "Missing file: $file"
done

# Create disk image
echo "==> Creating disk image"

rm -f "$IMG"

truncate -s $((SECTORS * SECTOR_SIZE)) "$IMG"

# Create MBR partition table
echo "==> Creating MBR partition table"

parted -s -a none "$IMG" mklabel msdos

parted -s -a none "$IMG" \
    mkpart primary fat16 "${PARTITION_START}s" "${PARTITION_END}s"

parted -s "$IMG" set 1 boot on

# Change partition type to FAT12 (0x01)
echo "==> Setting FAT12 partition type"

printf '\001' | dd of="$IMG" bs=1 seek=450 \
    conv=notrunc 2>/dev/null

# Format FAT12 partition
echo "==> Formatting FAT12 partition"

mkfs.fat -F 12 -s 2 \
    -h "$PARTITION_START" \
    --offset="$PARTITION_START" \
    "$IMG" "$PARTITION_BLOCKS"

# mtools partition offset (in bytes)
VOLUME="${IMG}@@${PARTITION_OFFSET}"

# Copy boot files
echo "==> Creating boot directory"

mmd -i "$VOLUME" ::/boot

echo "==> Copying kernel"

mcopy -i "$VOLUME" "$KERN" ::/boot/kernel.elf

echo "==> Copying Limine configuration"

mcopy -i "$VOLUME" "$CONFIG" ::/limine.conf

echo "==> Copying Limine BIOS system file"

mcopy -i "$VOLUME" "$LIMINE_SYS" ::/limine-bios.sys

# Install Limine BIOS bootloader
echo "==> Installing Limine BIOS bootloader"

"$LIMINE" bios-install "$IMG"

# Verify image
echo "==> Verifying image"

parted -s "$IMG" print

echo "==> Verifying FAT12 filesystem"

mdir -i "$VOLUME" ::

echo "==> Verifying boot directory"

mdir -i "$VOLUME" ::/boot

echo "==> Successfully created $IMG"

