#!/bin/bash
set -e

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 ts7700 raspberrypi3'
goVersions='1.4.3 1.5.3 1.6'
resinUrl="http://resin-packages.s3.amazonaws.com/golang/v\$GO_VERSION/go\$GO_VERSION.linux-#{TARGET_ARCH}.tar.gz"
golangUrl="https://storage.googleapis.com/golang/go\$GO_VERSION.linux-#{TARGET_ARCH}.tar.gz"

for device in $devices; do
	case "$device" in
	'raspberrypi')
		binary_url=$resinUrl
		binary_arch='armv6hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'raspberrypi2')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'raspberrypi3')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'beaglebone')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'edison')
		binary_url=$golangUrl
		binary_arch='386'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-i386'
	;;
	'nuc')
		binary_url=$golangUrl
		binary_arch='amd64'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-amd64'
	;;
	'vab820-quad')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'zc702-zynq7')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'odroid-c1')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'odroid-ux3')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'parallella-hdmi-resin')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'nitrogen6x')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'cubox-i')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'ts4900')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'colibri-imx6')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'apalis-imx6')
		binary_url=$resinUrl
		binary_arch='armv7hf'
		alpine_binary_url=$resinUrl
		alpine_binary_arch='alpine-armhf'
	;;
	'ts7700')
		binary_url=$resinUrl
		binary_arch='armel'
		# Not supported yet
		#alpine_binary_url=$resinUrl
		#alpine_binary_arch='alpine-armhf'
	;;
	esac
	for goVersion in $goVersions; do
		baseVersion=$(expr match "$goVersion" '\([0-9]*\.[0-9]*\)')

		# Debian.

		# Extract checksum
		checksum=$(grep " go$goVersion.linux-$binary_arch.tar.gz" SHASUMS256.txt)

		debian_dockerfilePath=$device/debian/$baseVersion
		mkdir -p $debian_dockerfilePath
		sed -e s~#{FROM}~resin/$device-buildpack-deps:jessie~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{GO_VERSION}~$goVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.tpl > $debian_dockerfilePath/Dockerfile
		cp go-wrapper $debian_dockerfilePath/

		mkdir -p $debian_dockerfilePath/wheezy
		sed -e s~#{FROM}~resin/$device-buildpack-deps:wheezy~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{GO_VERSION}~$goVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.tpl > $debian_dockerfilePath/wheezy/Dockerfile
		cp go-wrapper $debian_dockerfilePath/wheezy/

		# Golang doesn't work properly with qemu when cross compiling, so ARM build servers are required to build onbuild images properly.
		#mkdir -p $debian_dockerfilePath/onbuild
		#sed -e s~#{FROM}~resin/$device-go:$goVersion~g Dockerfile.onbuild.tpl > $debian_dockerfilePath/onbuild/Dockerfile
		
		# Only for RPI1 device
		if [ $device == "raspberrypi" ]; then
			base_image="resin/$device-systemd:jessie"
		else
			base_image="resin/$device-debian:jessie"
		fi

		mkdir -p $debian_dockerfilePath/slim
		sed -e s~#{FROM}~resin/$base_image~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{GO_VERSION}~$goVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
		cp go-wrapper $debian_dockerfilePath/slim/

		# Alpine.

		# TS7700 not supported yet
		if [ $device == "ts7700" ]; then
			continue
		fi

		# Extract checksum
		checksum=$(grep " go$goVersion.linux-$alpine_binary_arch.tar.gz" SHASUMS256.txt)

		alpine_dockerfilePath=$device/alpine/$baseVersion

		mkdir -p $alpine_dockerfilePath
		sed -e s~#{FROM}~"resin/$device-alpine-buildpack-deps:latest"~g \
			-e s~#{BINARY_URL}~"$alpine_binary_url"~g \
			-e s~#{GO_VERSION}~"$goVersion"~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~"$alpine_binary_arch"~g Dockerfile.alpine.tpl > $alpine_dockerfilePath/Dockerfile
		cp go-wrapper $alpine_dockerfilePath/

		mkdir -p $alpine_dockerfilePath/slim
		sed -e s~#{FROM}~"resin/$device-alpine:latest"~g \
			-e s~#{BINARY_URL}~"$alpine_binary_url"~g \
			-e s~#{GO_VERSION}~"$goVersion"~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~"$alpine_binary_arch"~g Dockerfile.alpine.slim.tpl > $alpine_dockerfilePath/slim/Dockerfile
		cp go-wrapper $alpine_dockerfilePath/slim/

		mkdir -p $alpine_dockerfilePath/edge
		sed -e s~#{FROM}~"resin/$device-alpine-buildpack-deps:edge"~g \
			-e s~#{BINARY_URL}~"$alpine_binary_url"~g \
			-e s~#{GO_VERSION}~"$goVersion"~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~"$alpine_binary_arch"~g Dockerfile.alpine.tpl > $alpine_dockerfilePath/edge/Dockerfile
		cp go-wrapper $alpine_dockerfilePath/edge/
	done
done
