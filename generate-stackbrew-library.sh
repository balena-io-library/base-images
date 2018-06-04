#!/bin/bash
set -e

self="$(basename "$0")"
root="$(dirname "$(readlink -f "$BASH_SOURCE[0]")")"
images='debian alpine fedora'

usage() {
    cat <<EOUSAGE

usage: $self [image|all]
   ie: $self debian
       $self all

This script generates stackbrew library for the specified Dockerfiles.

Supported image: debian, alpine, fedora. Passing 'all' will generate the library file for all Dockerfiles.

EOUSAGE
}

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    usage
    exit 1
fi

for arg in "$@"
do
case $arg in
    'alpine')
        bash "$root/scripts/stackbrew-library/generate-alpine-stackbrew-library.sh"
    ;;
    'debian')
        bash "$root/scripts/stackbrew-library/generate-debian-stackbrew-library.sh"
    ;;
    'fedora')
        bash "$root/scripts/stackbrew-library/generate-fedora-stackbrew-library.sh"
    ;;
    'all')
        for image in $images; do
            bash "$root/scripts/stackbrew-library/generate-$image-stackbrew-library.sh"
        done
    ;;
    *)
        {
            echo "error: unknown argument: $arg"
            usage
        } >&2
        exit 1
    ;;
esac
done

