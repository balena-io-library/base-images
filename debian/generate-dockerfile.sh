#!/bin/bash
set -e
set -o pipefail

archs='armv7hf i386 amd64 armel'
QEMU_VERSION='2.5.0-resin-rc3'
QEMU_SHA256='dc36002fd3e362710e1654c4dfdc84a064b710e10a2323e8e4c8e24cb3921818'

# Download QEMU
curl -SLO https://github.com/resin-io/qemu/releases/download/$QEMU_VERSION/qemu-$QEMU_VERSION.tar.gz \
	&& echo "$QEMU_SHA256  qemu-$QEMU_VERSION.tar.gz" > qemu-$QEMU_VERSION.tar.gz.sha256sum \
	&& sha256sum -c qemu-$QEMU_VERSION.tar.gz.sha256sum \
	&& tar -xz --strip-components=1 -f qemu-$QEMU_VERSION.tar.gz
chmod +x qemu-arm-static

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
			cp qemu-arm-static $dockerfilePath/
		fi
	done
done
rm -rf qemu*
