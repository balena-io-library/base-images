#!/usr/bin/env bash

# $1 path
function RefactorDirs() {
	echo "$1"
    dirName=$(basename "$1")
    parentDir="$(dirname "$1")"
    if [ $dirName == 'latest' ]; then
        mv "$1"/* "$parentDir/"
    fi
}

QEMU_VERSION='2.9.0.resin1-arm'
QEMU_SHA256='b39d6a878c013abb24f4cccc7c3a79829546ae365069d5712142a4ad21bcb91b'
QEMU_AARCH64_VERSION='2.9.0.resin1-aarch64'
QEMU_AARCH64_SHA256='ebd9c4f4ab005f183b8d84b121b5b791c39c5a92013e590e00705e958c5b5c48'
RESIN_XBUILD_VERSION='1.0.0'
RESIN_XBUILD_SHA256='1eb099bc3176ed078aa93bd5852dbab9219738d16434c87fc9af499368423437'
TINI_VERSION='0.14.0'

# Download QEMU
curl -SLO https://github.com/resin-io/qemu/releases/download/v2.9.0+resin1/qemu-$QEMU_VERSION.tar.gz \
	&& echo "$QEMU_SHA256  qemu-$QEMU_VERSION.tar.gz" | sha256sum -c - \
	&& tar -xz --strip-components=1 -f qemu-$QEMU_VERSION.tar.gz
curl -SLO https://github.com/resin-io/qemu/releases/download/v2.9.0+resin1/qemu-$QEMU_AARCH64_VERSION.tar.gz \
	&& echo "$QEMU_AARCH64_SHA256  qemu-$QEMU_AARCH64_VERSION.tar.gz" | sha256sum -c - \
	&& tar -xz --strip-components=1 -f qemu-$QEMU_AARCH64_VERSION.tar.gz
curl -SLO http://resin-packages.s3.amazonaws.com/resin-xbuild/v$RESIN_XBUILD_VERSION/resin-xbuild$RESIN_XBUILD_VERSION.tar.gz \
	&& echo "$RESIN_XBUILD_SHA256  resin-xbuild$RESIN_XBUILD_VERSION.tar.gz" | sha256sum -c - \
	&& tar -xzf resin-xbuild$RESIN_XBUILD_VERSION.tar.gz
chmod +x qemu-arm-static qemu-aarch64-static resin-xbuild

#IMAGE_TYPES='node debian alpine device-base buildpack-deps golang python'
IMAGE_TYPES='debian'
TARGET_DIR='resin-base-images'

./node_modules/.bin/coffee ./build/build.coffee

export -f RefactorDirs
find "../$TARGET_DIR" -type d -exec bash -c 'RefactorDirs "$0"' {} \;
find "../$TARGET_DIR" -name 'latest' -type d -empty -delete

for image_type in $IMAGE_TYPES; do
	cp "supporting_files/$image_type.generate-stackbrew-library.sh" "../resin-base-images/$image_type/generate-stackbrew-library.sh"
done

rm -rf qemu-* resin-xbuild*