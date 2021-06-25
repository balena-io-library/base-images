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

    case "$os" in
        debian|raspbian|alpine|fedora)
            if [ "$os_version" == "sid" ] ; then
                # skip the os test for Debian sid
                echo "OS version test skipped!"; exit 0
            fi
            [[ "$PRETTY_NAME" == *"$os_version"* ]] || (echo "Incorrect OS version!"; exit 1)
        ;;
        ubuntu)
            [[ "$os_version" == "$VERSION_CODENAME" ]] || (echo "Incorrect OS version!"; exit 1)
        ;;
        *)
            echo "Unsure how to handle OS version for $OS_NAME, skipping test..."; exit 0
    esac
    echo "OS version test passed!"
}

check_os_version
