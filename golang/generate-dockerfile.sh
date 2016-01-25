#!/bin/bash
set -e

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 ts7700'
goVersions='1.4.3 1.5.2'
resinUrl="http://resin-packages.s3.amazonaws.com/golang/v\$GO_VERSION/go-v\$GO_VERSION-linux-#{TARGET_ARCH}.tar.gz"
golangUrl="https://storage.googleapis.com/golang/go\$GO_VERSION.linux-#{TARGET_ARCH}.tar.gz"

for device in $devices; do
	case "$device" in
	'raspberrypi')
		binary_url=$resinUrl
		binary_arch='armv6hf'
	;;
	'raspberrypi2')
		binary_url=$resinUrl
		binary_arch='armv7hf'
	;;
	'beaglebone')
		binary_url=$resinUrl
		binary_arch='armv7hf'
	;;
	'edison')
		binary_url=$golangUrl
		binary_arch='386'
	;;
	'nuc')
		binary_url=$golangUrl
		binary_arch='amd64'
	;;
	'vab820-quad')
		binary_url=$resinUrl
		binary_arch='armv7hf'
	;;
	'zc702-zynq7')
		binary_url=$resinUrl
		binary_arch='armv7hf'
	;;
	'odroid-c1')
		binary_url=$resinUrl
		binary_arch='armv7hf'
	;;
	'odroid-ux3')
		binary_url=$resinUrl
		binary_arch='armv7hf'
	;;
	'parallella-hdmi-resin')
		binary_url=$resinUrl
		binary_arch='armv7hf'
	;;
	'nitrogen6x')
		binary_url=$resinUrl
		binary_arch='armv7hf'
	;;
	'cubox-i')
		binary_url=$resinUrl
		binary_arch='armv7hf'
	;;
	'ts4900')
		binary_url=$resinUrl
		binary_arch='armv7hf'
	;;
	'colibri-imx6')
		binary_url=$resinUrl
		binary_arch='armv7hf'
	;;
	'apalis-imx6')
		binary_url=$resinUrl
		binary_arch='armv7hf'
	;;
	'ts7700')
		binary_url=$resinUrl
		binary_arch='armel'
	;;
	esac
	for goVersion in $goVersions; do
		baseVersion=$(expr match "$goVersion" '\([0-9]*\.[0-9]*\)')

		dockerfilePath=$device/$baseVersion
		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~resin/$device-buildpack-deps:jessie~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{GO_VERSION}~$goVersion~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.tpl > $dockerfilePath/Dockerfile
		cp go-wrapper $dockerfilePath/

		mkdir -p $dockerfilePath/wheezy
		sed -e s~#{FROM}~resin/$device-buildpack-deps:wheezy~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{GO_VERSION}~$goVersion~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.tpl > $dockerfilePath/wheezy/Dockerfile
		cp go-wrapper $dockerfilePath/wheezy/

		# Golang doesn't work properly with qemu when cross compiling, so ARM build servers are required to build onbuild images properly.
		#mkdir -p $dockerfilePath/onbuild
		#sed -e s~#{FROM}~resin/$device-go:$goVersion~g Dockerfile.onbuild.tpl > $dockerfilePath/onbuild/Dockerfile
		mkdir -p $dockerfilePath/slim

		# Only for RPI1 device
		if [ $device == "raspberrypi" ]; then
			sed -e s~#{FROM}~resin/$device-systemd:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{GO_VERSION}~$goVersion~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.slim.tpl > $dockerfilePath/slim/Dockerfile
		else
			sed -e s~#{FROM}~resin/$device-debian:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{GO_VERSION}~$goVersion~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.slim.tpl > $dockerfilePath/slim/Dockerfile
		fi
		cp go-wrapper $dockerfilePath/slim/

	done
done
