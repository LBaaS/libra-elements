#!/bin/bash

set -x

# A helper script to do all the necassary actions to actually get ready for building images.

dist=`lsb_release -is`

install_deps() {
    case $dist in
        Ubuntu)
            sudo apt-get update -q
            sudo apt-get install -qy git qemu kpartx
        ;;
        Fedora)
            sudo yum update -y
            sudo yum install -y git qemu kpartx
        ;;
    esac
}


git_clone() {
    local src=$1
    local target=$2

    [ ! -d $target ] && {
        git clone $src $target
    } || {
        cd $target
        git pull origin master
    }
}


clone_repos() {
    reload_env
    git_clone https://github.com/openstack/diskimage-builder $DIB_PATH
    git_clone https://github.com/LBaaS/libra-elements $LIBRA_ELEMENTS
}


add_export() {
    echo ""
    #[ -z "$"]
    local string="$1"

}

setup_profile() {
    cat >$HOME/.dib_profile<<EOF
export DIB_PATH=\$HOME/diskimage-builder
export PATH=$PATH:\$DIB_PATH/bin
export LIBRA_ELEMENTS=\$HOME/libra-elements
export ELEMENTS_PATH=\$DIB_PATH/elements:\$LIBRA_ELEMENTS/elements
EOF
    echo "Now ready, please do:"
    echo "source $HOME/.bashrc"

    [ -z "$(egrep dib_profile $HOME/.bashrc)" ] && {
        echo "source $HOME/.dib_profile" >> $HOME/.bashrc
    }
}

reload_env() {
    . ~/.bashrc
}

case $1 in
    deps)
        install_deps
    ;;
    profile)
        setup_profile
    ;;
    clone)
        clone_repos
    ;;
    *)
        install_deps
        setup_profile
        reload_env
        clone_repos
    ;;
esac
