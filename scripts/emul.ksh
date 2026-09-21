#!/bin/ksh
#
# emul.ksh -- run the ISO on QEMU
#

set -eu

DISK="euclid64.iso"

./scripts/disk.ksh

exec qemu-system-x86_64 \
	-cdrom "$DISK" \
	-m 128M \
	-serial stdio \
	-no-reboot \
	-no-shutdown

