#!/bin/ksh
#
# emul.ksh -- run the ISO on QEMU
#

set -eu

DISK="euclid64.iso"

if ! [[ -f "$DISK" ]]; then
	./scripts/disk.ksh
fi

exec qemu-system-x86_64 \
	-cdrom "$DISK" \
	-m 128M \
	-serial stdio \
	-no-reboot \
	-no-shutdown

