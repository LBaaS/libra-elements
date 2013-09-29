#!/bin/bash

set -x

nbd=/dev/nbd0
image=$1
file=$2
part=$3


[ ! -r "$image" ] && {
    echo "Image file not found"
    exit 0
}

[ ! -r "$file" ] && {
    echo "File $file is missing"
    exit 0
}

[ $(egrep $nbd /proc/mounts) ] && {
    echo "NBD $nbd is mounted already, please unmount and try again"
    exit 0
}

tmp_dir=/tmp/worker-$(uuidgen)

sudo qemu-nbd $image -c $nbd

sudo mkdir $tmp_dir

sudo mount ${nbd}${part} $tmp_dir

sudo cp $file $tmp_dir/etc/libra.cfg

sudo umount $tmp_dir

sudo qemu-nbd -d $nbd
