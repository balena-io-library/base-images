#!/bin/bash
set -e

function version_le() { test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" != "$1"; }

# List of devices
targets='raspberry-pi raspberry-pi2 beaglebone-black intel-edison intel-nuc via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q ts7700 raspberrypi3 artik5 artik10 beaglebone-green-wifi qemux86 qemux86-64 beaglebone-green cybertan-ze250 artik710 am571x-evm up-board kitra710 imx6ul-var-dart kitra520 jetson-tx2 iot2000 jetson-tx1 generic-armv7ahf generic-aarch64 bananapi-m1-plus orangepi-plus2'
# List of archs
targets+=' armv7hf armel i386 amd64 aarch64'
fedora_targets=' raspberry-pi2 beaglebone-black via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q raspberrypi3 artik5 artik10 beaglebone-green-wifi beaglebone-green intel-nuc qemux86-64 artik710 am571x-evm kitra710 up-board imx6ul-var-dart kitra520 jetson-tx2 jetson-tx1 armv7hf amd64 aarch64 generic-armv7ahf generic-aarch64 bananapi-m1-plus orangepi-plus2 '
goVersions='1.4.3 1.5.4 1.6.4 1.7.5 1.8.7 1.9.4 1.10'
resinUrl="http://resin-packages.s3.amazonaws.com/golang/v\$GO_VERSION/go\$GO_VERSION.linux-#{TARGET_ARCH}.tar.gz"
golangUrl="https://storage.googleapis.com/golang/go\$GO_VERSION.linux-#{TARGET_ARCH}.tar.gz"

for target in $targets; do
	case "$target" in
	'armv7hf'|'generic-armv7ahf'|'bananapi-m1-plus'|'orangepi-plus2')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'armel')
		binary_url=$resinUrl
		binary_arch='armel'
	;;
	'i386')
		binary_url=$golangUrl
		binary_arch='386'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-i386'
	;;
	'amd64')
		binary_url=$golangUrl
		binary_arch='amd64'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-amd64'
		fedora_binary_url=$golangUrl
		fedora_binary_arch='amd64'
	;;
	'aarch64')
		binary_url=$resinUrl
		binary_arch='aarch64'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-aarch64'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='aarch64'
	;;
	'raspberry-pi')
		binary_url=$resinUrl
		binary_arch='armv6hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'raspberry-pi2')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'raspberrypi3')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'beaglebone-black')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'beaglebone-green-wifi')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'beaglebone-green')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'intel-edison')
		binary_url=$golangUrl
		binary_arch='386'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-i386'
	;;
	'cybertan-ze250')
		binary_url=$resinUrl
		binary_arch='i386'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-i386'
	;;
	'iot2000')
		binary_url=$resinUrl
		binary_arch='i386'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-i386'
	;;
	'qemux86')
		binary_url=$golangUrl
		binary_arch='386'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-i386'
	;;
	'intel-nuc')
		binary_url=$golangUrl
		binary_arch='amd64'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-amd64'
		fedora_binary_url=$golangUrl
		fedora_binary_arch='amd64'
	;;
	'qemux86-64')
		binary_url=$golangUrl
		binary_arch='amd64'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-amd64'
		fedora_binary_url=$golangUrl
		fedora_binary_arch='amd64'
	;;
	'up-board')
		binary_url=$golangUrl
		binary_arch='amd64'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-amd64'
		fedora_binary_url=$golangUrl
		fedora_binary_arch='amd64'
	;;
	'via-vab820-quad')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'zynq-xz702')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'odroid-c1')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'odroid-xu4')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'parallella')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'nitrogen6x')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'hummingboard')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'ts4900')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'colibri-imx6dl')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'apalis-imx6q')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'am571x-evm')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'ts7700')
		binary_url=$resinUrl
		binary_arch='armel'
		# Not supported yet
		#alpine_binary_url=$resinUrl
		#alpine_binary_arch='alpine-armhf'
	;;
	'artik5')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'artik10')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'kitra520')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'imx6ul-var-dart')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'ccon-01')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='armv7hf'
	;;
	'jetson-tx2'|'jetson-tx1'|'artik710'|'kitra710'|'generic-aarch64')
		binary_url=$resinUrl
		binary_arch='aarch64'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-aarch64'
		fedora_binary_url=$resinUrl
		fedora_binary_arch='aarch64'
	;;
	esac
	for goVersion in $goVersions; do
		baseVersion=$(expr match "$goVersion" '\([0-9]*\.[0-9]*\)')

		if ([ $target == "cybertan-ze250" ] || [ $target == "iot2000" ]) && ( version_le $goVersion "1.6" ); then
			continue
		fi

		# Only v1.6 and higher aarch64 binaries are available.
		if [ $binary_arch == "aarch64" ] && ( version_le $goVersion "1.6" ); then
			continue
		fi

		# Debian.

		# Extract checksum
		checksum=$(grep " go$goVersion.linux-$binary_arch.tar.gz" SHASUMS256.txt)

		debian_dockerfilePath=$target/debian/$baseVersion
		mkdir -p $debian_dockerfilePath
		sed -e s~#{FROM}~resin/$target-buildpack-deps:jessie~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{GO_VERSION}~$goVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.tpl > $debian_dockerfilePath/Dockerfile
		cp go-wrapper $debian_dockerfilePath/

		mkdir -p $debian_dockerfilePath/stretch
		sed -e s~#{FROM}~resin/$target-buildpack-deps:stretch~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{GO_VERSION}~$goVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.tpl > $debian_dockerfilePath/stretch/Dockerfile
		cp go-wrapper $debian_dockerfilePath/stretch/

		mkdir -p $debian_dockerfilePath/onbuild
		sed -e s~#{FROM}~resin/$target-golang:$goVersion~g Dockerfile.onbuild.tpl > $debian_dockerfilePath/onbuild/Dockerfile
		
		# Only for RPI1 target
		if [ $target == "raspberry-pi" ]; then
			base_image="resin/rpi-raspbian:jessie"
		else
			base_image="resin/$target-debian:jessie"
		fi

		mkdir -p $debian_dockerfilePath/slim
		sed -e s~#{FROM}~$base_image~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{GO_VERSION}~$goVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
		cp go-wrapper $debian_dockerfilePath/slim/

		# Fedora

		if [[ $fedora_targets == *" $target "* ]]; then
			fedora_dockerfilePath=$target/fedora/$baseVersion
			mkdir -p $fedora_dockerfilePath
			sed -e s~#{FROM}~resin/$target-fedora-buildpack-deps:latest~g \
				-e s~#{BINARY_URL}~$fedora_binary_url~g \
				-e s~#{GO_VERSION}~$goVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$fedora_binary_arch~g Dockerfile.tpl > $fedora_dockerfilePath/Dockerfile
			cp go-wrapper $fedora_dockerfilePath/

			mkdir -p $fedora_dockerfilePath/25
			sed -e s~#{FROM}~resin/$target-fedora-buildpack-deps:25~g \
				-e s~#{BINARY_URL}~$fedora_binary_url~g \
				-e s~#{GO_VERSION}~$goVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$fedora_binary_arch~g Dockerfile.tpl > $fedora_dockerfilePath/25/Dockerfile
			cp go-wrapper $fedora_dockerfilePath/25/

			mkdir -p $fedora_dockerfilePath/onbuild
			sed -e s~#{FROM}~resin/$target-fedora-golang:$goVersion~g Dockerfile.onbuild.tpl > $fedora_dockerfilePath/onbuild/Dockerfile

			mkdir -p $fedora_dockerfilePath/slim
			sed -e s~#{FROM}~resin/$target-fedora:latest~g \
					-e s~#{BINARY_URL}~$fedora_binary_url~g \
					-e s~#{GO_VERSION}~$goVersion~g \
					-e s~#{CHECKSUM}~"$checksum"~g \
					-e s~#{TARGET_ARCH}~$fedora_binary_arch~g Dockerfile.fedora.slim.tpl > $fedora_dockerfilePath/slim/Dockerfile
			cp go-wrapper $fedora_dockerfilePath/slim/

		fi

		# Alpine.

		# TS7700 not supported yet
		if [ $target == "ts7700" ] || [ $target == "armel" ]; then
			continue
		fi

		if [ $target == "armv7hf" ]; then
			target='armhf'
		fi

		# Extract checksum
		checksum=$(grep " go$goVersion.linux-$alpine_binary_arch.tar.gz" SHASUMS256.txt)

		alpine_dockerfilePath=$target/alpine/$baseVersion

		mkdir -p $alpine_dockerfilePath
		sed -e s~#{FROM}~"resin/$target-alpine-buildpack-deps:latest"~g \
			-e s~#{BINARY_URL}~"$alpine_binary_url"~g \
			-e s~#{GO_VERSION}~"$goVersion"~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~"$alpine_binary_arch"~g Dockerfile.alpine.tpl > $alpine_dockerfilePath/Dockerfile
		cp go-wrapper $alpine_dockerfilePath/

		mkdir -p $alpine_dockerfilePath/slim
		sed -e s~#{FROM}~"resin/$target-alpine:latest"~g \
			-e s~#{BINARY_URL}~"$alpine_binary_url"~g \
			-e s~#{GO_VERSION}~"$goVersion"~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~"$alpine_binary_arch"~g Dockerfile.alpine.slim.tpl > $alpine_dockerfilePath/slim/Dockerfile
		cp go-wrapper $alpine_dockerfilePath/slim/

		mkdir -p $alpine_dockerfilePath/onbuild
		sed -e s~#{FROM}~resin/$target-alpine-golang:$goVersion~g Dockerfile.onbuild.tpl > $alpine_dockerfilePath/onbuild/Dockerfile

		mkdir -p $alpine_dockerfilePath/edge
		sed -e s~#{FROM}~"resin/$target-alpine-buildpack-deps:edge"~g \
			-e s~#{BINARY_URL}~"$alpine_binary_url"~g \
			-e s~#{GO_VERSION}~"$goVersion"~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~"$alpine_binary_arch"~g Dockerfile.alpine.tpl > $alpine_dockerfilePath/edge/Dockerfile
		cp go-wrapper $alpine_dockerfilePath/edge/

	done
done
