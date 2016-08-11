#!/bin/bash
set -e
set -o pipefail

archs='armv7hf i386 amd64 armel aarch64'
QEMU_VERSION='2.5.0-resin-rc3-arm'
QEMU_SHA256='107f0585f2b98a149b0ff013ec068ac24c6cfc402cd438b6da5251406bcd564c'
QEMU_AARCH64_VERSION='2.5.0-resin-rc3-aarch64'
QEMU_AARCH64_SHA256='d23d8d071f291930fc727cd752b4b0b39a159138efdceb0858dec9710698db9f'

# Download QEMU
curl -SLO https://github.com/resin-io/qemu/releases/download/qemu-$QEMU_VERSION/qemu-$QEMU_VERSION.tar.gz \
	&& echo "$QEMU_SHA256  qemu-$QEMU_VERSION.tar.gz" | sha256sum -c - \
	&& tar -xz --strip-components=1 -f qemu-$QEMU_VERSION.tar.gz
curl -SLO https://github.com/resin-io/qemu/releases/download/qemu-$QEMU_AARCH64_VERSION/qemu-$QEMU_AARCH64_VERSION.tar.gz \
	&& echo "$QEMU_AARCH64_SHA256  qemu-$QEMU_AARCH64_VERSION.tar.gz" | sha256sum -c - \
	&& tar -xz --strip-components=1 -f qemu-$QEMU_AARCH64_VERSION.tar.gz
chmod +x qemu-arm-static qemu-aarch64-static

for arch in $archs; do
	case "$arch" in
	'armv7hf')
		baseImage='armhf/debian'
		label='io.resin.architecture="armv7hf" io.resin.qemu.version="'$QEMU_VERSION'"'
		suites='jessie wheezy sid'
		qemu='COPY qemu-arm-static /usr/bin/'
	;;
	'i386')
		baseImage='i386/debian'
		label='io.resin.architecture="i386"'
		suites='jessie wheezy'
		qemu=''
	;;
	'amd64')
		baseImage='debian'
		label='io.resin.architecture="amd64"'
		suites='jessie wheezy'
		qemu=''
	;;
	'armel')
		baseImage='armel/debian'
		label='io.resin.architecture="armv5e" io.resin.qemu.version="'$QEMU_VERSION'"'
		suites='jessie wheezy'
		qemu='COPY qemu-arm-static /usr/bin/'
	;;
	'aarch64')
		baseImage='aarch64/debian'
		label='io.resin.architecture="aarch64" io.resin.qemu.version="'$QEMU_AARCH64_VERSION'"'
		suites='jessie'
		qemu='COPY qemu-aarch64-static /usr/bin/'
	;;
	esac
	for suite in $suites; do

		dockerfilePath=$arch/$suite
		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~$baseImage:$suite~g \
			-e s~#{LABEL}~"$label"~g \
			-e s~#{QEMU}~"$qemu"~g Dockerfile.tpl > $dockerfilePath/Dockerfile
		cp 01_nodoc 01_buildconfig $dockerfilePath/

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
rm -rf qemu*
