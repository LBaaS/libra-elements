#!/bin/bash

# A helper script to do all the necassary actions to actually get ready for building images.

dist=`lsb_release -is`

case $dist in
    Ubuntu)
        apt-get update -q
        apt-get install -qy git qemu kpartx
    ;;
    Fedora)
        yum update -y
        yum install -y git qemu kpartx
    ;;
esac

echo 'export DIB_PATH=$HOME/diskimage-builder' >> ~/.bashrc
echo 'export PATH=$PATH:$DIB_PATH/bin' >> ~/.bashrc
echo 'export LIBRA_ELEMENTS=$HOME/libra-elements' >> ~/.bashrc

echo 'export ELEMENTS_PATH=$DI_BUILDER_PATH/elements:$LIBRA_ELEMENTS' >> ~/.bashrc

. ~/.bashrc

git clone https://github.com/openstack/diskimage-builder $DIB_PATH
git clone http://github.com/lbaas/libra-elements $LIBRA_ELEMENTS

echo "Now ready, please do\n. ~/.bashrc"
