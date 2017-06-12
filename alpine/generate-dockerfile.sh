#!/bin/bash
set -e

repos='armhf i386 amd64 aarch64'
suites='edge 3.2 3.3 3.4 3.5'
QEMU_VERSION='2.9.0.resin1-arm'
QEMU_SHA256='b39d6a878c013abb24f4cccc7c3a79829546ae365069d5712142a4ad21bcb91b'
QEMU_AARCH64_VERSION='2.9.0.resin1-aarch64'
QEMU_AARCH64_SHA256='ebd9c4f4ab005f183b8d84b121b5b791c39c5a92013e590e00705e958c5b5c48'
RESIN_XBUILD_VERSION='1.0.0'
RESIN_XBUILD_SHA256='1eb099bc3176ed078aa93bd5852dbab9219738d16434c87fc9af499368423437'

function version_le() { test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" != "$1"; }

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

chmod +x entry.sh qemu-arm-static resin qemu-aarch64-static resin-xbuild
for repo in $repos; do
	case "$repo" in
	'armhf')
		baseImage='armhf/alpine'
		label="LABEL io.resin.architecture=\"armhf\" io.resin.qemu.version=\"$QEMU_VERSION\""
		qemu='COPY qemu-arm-static /usr/bin/qemu-arm-static'
	;;
	'i386')
		baseImage='i386/alpine'
		label="LABEL io.resin.architecture=\"i386\""
		qemu=''
	;;
	'amd64')
		baseImage='alpine'
		label="LABEL io.resin.architecture=\"amd64\""
		qemu=''
	;;
	'aarch64')
		baseImage='aarch64/alpine'
		label="LABEL io.resin.architecture=\"aarch64\" io.resin.qemu.version=\"$QEMU_VERSION\""
		qemu='COPY qemu-aarch64-static /usr/bin/qemu-aarch64-static'
	;;
	esac
	for suite in $suites; do
		# aarch64 images are available only with alpine linux 3.5 and higher.
		if [ $repo == "aarch64" ] && (version_le $suite "3.5"); then
			continue
		fi

		dockerfilePath=$repo/$suite
		mkdir -p $dockerfilePath

		sed -e s~#{FROM}~"$baseImage:$suite"~g \
			-e s~#{LABEL}~"$label"~g \
			-e s~#{QEMU}~"$qemu"~g Dockerfile.tpl > $dockerfilePath/Dockerfile
		cp entry.sh resin rc.conf resin-xbuild $dockerfilePath/

		if [ $repo == "armhf" ]; then
			cp qemu-arm-static $dockerfilePath/
		fi
		if [ $repo == "aarch64" ]; then
			cp qemu-aarch64-static $dockerfilePath/
		fi
	done
done

rm -rf qemu-* resin-xbuild*
