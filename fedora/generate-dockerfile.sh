#!/bin/bash
set -e

repos='armv7hf amd64 aarch64'
suites='24 25'
QEMU_VERSION='2.9.0.resin1-arm'
QEMU_SHA256='b39d6a878c013abb24f4cccc7c3a79829546ae365069d5712142a4ad21bcb91b'
QEMU_AARCH64_VERSION='2.9.0.resin1-aarch64'
QEMU_AARCH64_SHA256='ebd9c4f4ab005f183b8d84b121b5b791c39c5a92013e590e00705e958c5b5c48'
RESIN_XBUILD_VERSION='1.0.0'
RESIN_XBUILD_SHA256='1eb099bc3176ed078aa93bd5852dbab9219738d16434c87fc9af499368423437'
TINI_VERSION='0.14.0'
TINI_armv7hf='5926f7d9e4442025bbf8f277bde1accc183be4952c3e3f601aece3fdbcdcd9df  tini0.14.0.linux-armv7hf.tar.gz'
TINI_aarch64='5bfe3dcf7b41476c3ed99f886ac8a1ace2f72d4d5b04328de4a690b4dbec37b5  tini0.14.0.linux-aarch64.tar.gz'
TINI_amd64='ed4f65aa016b7efded7948b21fd654718e7a1e4deb6521bf4ca39f956f985e4d  tini0.14.0.linux-amd64.tar.gz'

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

chmod +x entry.sh qemu-arm-static qemu-aarch64-static resin-xbuild
for repo in $repos; do
	case "$repo" in
	'armv7hf')
		baseImage='arm32v7/fedora'
		label="LABEL io.resin.architecture=\"armv7hf\" io.resin.qemu.version=\"$QEMU_VERSION\""
		qemu='COPY qemu-arm-static /usr/bin/qemu-arm-static'
		template='Dockerfile.armv7hf.tpl'
	;;
	'amd64')
		baseImage='fedora'
		label="LABEL io.resin.architecture=\"amd64\""
		qemu=''
		template='Dockerfile.tpl'
	;;
	'aarch64')
		baseImage='arm64v8/fedora'
		label="LABEL io.resin.architecture=\"aarch64\" io.resin.qemu.version=\"$QEMU_VERSION\""
		qemu='COPY qemu-aarch64-static /usr/bin/qemu-aarch64-static'
		template='Dockerfile.tpl'
	;;
	esac

	# Tini
	tiniBinary="tini$TINI_VERSION.linux-$repo.tar.gz"
	tiniChecksum="TINI_$repo" && tiniChecksum=$(eval echo \$$tiniChecksum)

	for suite in $suites; do
		dockerfilePath=$repo/$suite
		mkdir -p $dockerfilePath

		sed -e s~#{FROM}~"$baseImage:$suite"~g \
			-e s~#{LABEL}~"$label"~g \
			-e s~#{QEMU}~"$qemu"~g \
			-e s~#{TINI_VERSION}~"$TINI_VERSION"~g \
			-e s~#{CHECKSUM}~"$tiniChecksum"~g \
			-e s~#{TINI_BINARY}~"$tiniBinary"~g "$template" > $dockerfilePath/Dockerfile
		cp entry.sh launch.service resin-xbuild $dockerfilePath/

		if [ $repo == "armv7hf" ]; then
			cp qemu-arm-static $dockerfilePath/
		fi
		if [ $repo == "aarch64" ]; then
			cp qemu-aarch64-static $dockerfilePath/
		fi
	done
done

rm -rf qemu-* resin-xbuild*
