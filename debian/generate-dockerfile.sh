#!/bin/bash
set -e
set -o pipefail

archs='armv7hf i386 amd64 armel aarch64'
QEMU_VERSION='2.9.0.resin1-arm'
QEMU_SHA256='b39d6a878c013abb24f4cccc7c3a79829546ae365069d5712142a4ad21bcb91b'
QEMU_AARCH64_VERSION='2.9.0.resin1-aarch64'
QEMU_AARCH64_SHA256='ebd9c4f4ab005f183b8d84b121b5b791c39c5a92013e590e00705e958c5b5c48'
RESIN_XBUILD_VERSION='1.0.0'
RESIN_XBUILD_SHA256='1eb099bc3176ed078aa93bd5852dbab9219738d16434c87fc9af499368423437'
TINI_VERSION='0.14.0'
TINI_armv6hf='0556dce389e01382ae6661afc53ea18fcf3ef195eee4e75b24a4e965571375f3  tini0.14.0.linux-armv6hf.tar.gz'
TINI_armv7hf='5926f7d9e4442025bbf8f277bde1accc183be4952c3e3f601aece3fdbcdcd9df  tini0.14.0.linux-armv7hf.tar.gz'
TINI_armel='536054e9a0c665876b7d4e975bdbf866f1fd0b884acf490f10f2ab4fa0aed19d  tini0.14.0.linux-armel.tar.gz'
TINI_aarch64='5bfe3dcf7b41476c3ed99f886ac8a1ace2f72d4d5b04328de4a690b4dbec37b5  tini0.14.0.linux-aarch64.tar.gz'
TINI_i386='d0c4baf134787b87b7124f44ce78674d0c8ec967217a874be7cd221946946397  tini0.14.0.linux-i386.tar.gz'
TINI_amd64='ed4f65aa016b7efded7948b21fd654718e7a1e4deb6521bf4ca39f956f985e4d  tini0.14.0.linux-amd64.tar.gz'

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

for arch in $archs; do
	case "$arch" in
	'armv7hf')
		baseImage='arm32v7/debian'
		label='io.resin.architecture="armv7hf" io.resin.qemu.version="'$QEMU_VERSION'"'
		suites='jessie wheezy sid stretch'
		variant='-slim'
		qemu='COPY qemu-arm-static /usr/bin/'
		qemuCpu=''
	;;
	'i386')
		baseImage='i386/debian'
		label='io.resin.architecture="i386"'
		suites='jessie wheezy stretch'
		variant='-slim'
		qemu=''
		qemuCpu=''
	;;
	'amd64')
		baseImage='debian'
		label='io.resin.architecture="amd64"'
		suites='jessie wheezy stretch'
		variant='-slim'
		qemu=''
		qemuCpu=''
	;;
	'armel')
		baseImage='armel/debian'
		label='io.resin.architecture="armv5e" io.resin.qemu.version="'$QEMU_VERSION'"'
		suites='jessie wheezy stretch'
		variant=''
		qemu='COPY qemu-arm-static /usr/bin/'
		qemuCpu='ENV QEMU_CPU arm1026'
	;;
	'aarch64')
		baseImage='arm64v8/debian'
		label='io.resin.architecture="aarch64" io.resin.qemu.version="'$QEMU_AARCH64_VERSION'"'
		suites='jessie stretch'
		variant='-slim'
		qemu='COPY qemu-aarch64-static /usr/bin/'
		qemuCpu=''
	;;
	esac

	# Tini
	tiniBinary="tini$TINI_VERSION.linux-$arch.tar.gz"
	tiniChecksum="TINI_$arch" && tiniChecksum=$(eval echo \$$tiniChecksum)

	for suite in $suites; do

		dockerfilePath=$arch/$suite
		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~$baseImage:$suite$variant~g \
			-e s~#{LABEL}~"$label"~g \
			-e s~#{QEMU_CPU}~"$qemuCpu"~g \
			-e s~#{QEMU}~"$qemu"~g \
			-e s~#{TINI_VERSION}~"$TINI_VERSION"~g \
			-e s~#{CHECKSUM}~"$tiniChecksum"~g \
			-e s~#{TINI_BINARY}~"$tiniBinary"~g Dockerfile.tpl > $dockerfilePath/Dockerfile
		cp 01_nodoc 01_buildconfig resin-xbuild $dockerfilePath/

		# ARM only
		if [ $arch != 'i386' ] && [ $arch != 'amd64' ]; then
			if [ $arch == 'aarch64' ]; then
				cp qemu-aarch64-static $dockerfilePath/
			else
				cp qemu-arm-static $dockerfilePath/
			fi
		fi

		# Systemd
		if [ $suite == 'wheezy' ]; then
			cat Dockerfile.no-systemd.partial >> $dockerfilePath/Dockerfile
			cp entry-nosystemd.sh $dockerfilePath/entry.sh
		else
			cat Dockerfile.systemd.partial >> $dockerfilePath/Dockerfile
			cp entry.sh launch.service $dockerfilePath/
		fi
	done
done
rm -rf qemu* resin-xbuild*
