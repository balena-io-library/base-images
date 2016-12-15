#!/bin/bash
set -e

repos='armhf i386 amd64'
suites='edge 3.2 3.3 3.4'
QEMU_VERSION='2.7.0-resin-rc2-arm'
QEMU_SHA256='2e65faa775b752b050516773338d61a29fe62c4c5fcd1186f972ffce3e205426'

# Download QEMU
curl -SLO https://github.com/resin-io/qemu/releases/download/qemu-$QEMU_VERSION/qemu-$QEMU_VERSION.tar.gz \
	&& echo "$QEMU_SHA256  qemu-$QEMU_VERSION.tar.gz" > qemu-$QEMU_VERSION.tar.gz.sha256sum \
	&& sha256sum -c qemu-$QEMU_VERSION.tar.gz.sha256sum \
	&& tar -xz --strip-components=1 -f qemu-$QEMU_VERSION.tar.gz

chmod +x entry.sh qemu-arm-static resin
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
	esac
	for suite in $suites; do
		dockerfilePath=$repo/$suite
		mkdir -p $dockerfilePath

		sed -e s~#{FROM}~"$baseImage:$suite"~g \
			-e s~#{LABEL}~"$label"~g \
			-e s~#{QEMU}~"$qemu"~g Dockerfile.tpl > $dockerfilePath/Dockerfile
		cp entry.sh resin rc.conf $dockerfilePath/

		if [ $repo == "armhf" ]; then
			cp qemu-arm-static $dockerfilePath/
		fi
	done
done

rm -rf qemu-*
