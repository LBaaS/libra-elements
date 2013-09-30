#!/bin/bash

set -x

# This script is meant to be used when downloading a pre-built image or when
# wanting to inject a libra.cfg file after building the file instead of having
# to rebuild the image fully.

# Requires: qemu-utils or alike that provides qemu-nbd.

IMAGE=${IMAGE:-$1} # Image to use
LIBRA_CFG=${LIBRA_CFG:-$2} # Config file to inject

NBD=${NBD:-/dev/nbd0} # NBD device to use
PART=${PART} # Partition on the NBD device to use, usually p1 is ok
TARET=${TARGET} # Default to empty and a random value if not set.


SCRIPT_DIR="$(dirname $0)"

. $SCRIPT_DIR/functions

[ ! -r "$LIBRA_CFG" ] && {
    echo "Config file '$LIBRA_CFG' is missing"
    exit 0
}

target=$(get_target $TARGET)

connect_nbd $IMAGE $NBD
mount_image ${NBD}${PART} $target

sudo cp $LIBRA_CFG $target/etc/libra.cfg

unmount_image $target
disconnect_nbd $NBD