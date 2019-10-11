#!/bin/bash

set -e

self="$(basename "$0")"

usage() {
	cat <<EOUSAGE

usage: $self [os] [os_version]
   ie: $self debian buster
       $self alpine 3.10

EOUSAGE
}

[ -z $1 ] && echo "OS missing!" && usage && exit 1
os="$1"

[ -z $2 ] && echo "OS version missing!" && usage && exit 1
os_version="$2"

function check_os_version {
    source /etc/os-release
    if [ "$ID" != "$os" ] ; then
        echo "Incorrect OS!"; exit 1
    fi

    if [ -n "$os_version" ]; then
        case "$os" in
            debian|raspbian|ubuntu)
                [[ "$VERSION_CODENAME" == "$os_version" ]] || (echo "Incorrect OS version!"; exit 1)
                ;;
            alpine)
                baseVersion=$(expr match "$VERSION_ID" '\([0-9]*\.[0-9]*\)')
                [[ "$baseVersion" == "$os_version" ]] || (echo "Incorrect OS version!"; exit 1)
                ;;
            fedora)
                [[ "$VERSION_ID" == "$os_version" ]] || (echo "Incorrect OS version!"; exit 1)
                ;;
            *)
                echo "Unsure how to handle OS version for $OS_NAME, skipping test..."; exit 0
        esac
        echo "OS version test passed!"
    fi
    echo "Empty OS version!"; exit 1
}

check_os_version
