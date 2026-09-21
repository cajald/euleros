#!/bin/ksh
#
# make_it_work.ksh -- makes some issues go away for some reason
#

rm -f euler64.iso
bmake clean
bmake all
./scripts/disk.ksh
echo "done"

