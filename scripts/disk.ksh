#!/bin/ksh
#
# disk.ksh -- make a Limine bootable ISO
#

set -eu

KERNEL="euclid/euclid64.elf"
LIMINE="Limine"
ISO_ROOT="iso_root"
ISO="euler64.iso"

if [[ ! -f "$KERNEL" ]]; then
	print -u2 "error: kernel not found: $KERNEL"
	exit 1
fi

if [[ ! -x "$LIMINE/limine" ]]; then
	print -u2 "error: Limine binary not found: $LIMINE/limine"
	print -u2 "clone the binary branch into '$LIMINE'"
	exit 1
fi

for file in \
	"$LIMINE/limine-bios.sys" \
	"$LIMINE/limine-bios-cd.bin" \
	"$LIMINE/limine-uefi-cd.bin" \
	"$LIMINE/BOOTX64.EFI"
do
	if [[ ! -f "$file" ]]; then
		print -u2 "error: missing Limine file: $file"
		exit 1
	fi
done

rm -rf "$ISO_ROOT" "$ISO"

mkdir -p "$ISO_ROOT/boot/limine"
mkdir -p "$ISO_ROOT/EFI/BOOT"

cp "$KERNEL" "$ISO_ROOT/boot/euclid.elf"

cat > "$ISO_ROOT/boot/limine/limine.conf" <<EOF
timeout: 5

/EulerOS
	protocol: multiboot1
	path: boot():/boot/euclid.elf
EOF

cp "$LIMINE/limine-bios.sys" \
   "$LIMINE/limine-bios-cd.bin" \
   "$LIMINE/limine-uefi-cd.bin" \
   "$ISO_ROOT/boot/limine/"

cp "$LIMINE/BOOTX64.EFI" \
   "$ISO_ROOT/EFI/BOOT/"

xorriso -as mkisofs \
	-R -r -J \
	-b boot/limine/limine-bios-cd.bin \
	-no-emul-boot \
	-boot-load-size 4 \
	-boot-info-table \
	-hfsplus \
	-apm-block-size 2048 \
	--efi-boot boot/limine/limine-uefi-cd.bin \
	-efi-boot-part \
	--efi-boot-image \
	--protective-msdos-label \
	"$ISO_ROOT" \
	-o "$ISO"

"$LIMINE/limine" bios-install "$ISO"

rm -rf "$ISO_ROOT"

print "created: $ISO"

