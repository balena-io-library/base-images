#!/bin/bash
set -e

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6'
nodeVersions='0.10.22 0.10.41 0.12.9 4.2.4 5.3.0'
defaultVersion='0.10.22' 
resinUrl="http://resin-packages.s3.amazonaws.com/node/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"
nodejsUrl="http://nodejs.org/dist/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"
# latest npm version
npmVersion='3.3.11'

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
		binary_url=$nodejsUrl
		binary_arch='x86'
	;;
	'nuc')
		binary_url=$nodejsUrl
		binary_arch='x64'
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
	esac
	for nodeVersion in $nodeVersions; do
		if [ $nodeVersion == $defaultVersion ]; then
			baseVersion='default'
		else
			baseVersion=$(expr match "$nodeVersion" '\([0-9]*\.[0-9]*\)')
		fi
		dockerfilePath=$device/$baseVersion
		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~resin/$device-buildpack-deps:jessie~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g \
			-e s~#{NPM_VERSION}~$npmVersion~g Dockerfile.tpl > $dockerfilePath/Dockerfile

		mkdir -p $dockerfilePath/wheezy
		sed -e s~#{FROM}~resin/$device-buildpack-deps:wheezy~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g \
			-e s~#{NPM_VERSION}~$npmVersion~g Dockerfile.tpl > $dockerfilePath/wheezy/Dockerfile

		mkdir -p $dockerfilePath/onbuild
		sed -e s~#{FROM}~resin/$device-node:$nodeVersion~g Dockerfile.onbuild.tpl > $dockerfilePath/onbuild/Dockerfile
		mkdir -p $dockerfilePath/slim

		# Only for RPI1 device
		if [ $device == "raspberrypi" ]; then
			sed -e s~#{FROM}~resin/$device-systemd:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g \
				-e s~#{NPM_VERSION}~$npmVersion~g Dockerfile.slim.tpl > $dockerfilePath/slim/Dockerfile
		else
			sed -e s~#{FROM}~resin/$device-debian:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g \
				-e s~#{NPM_VERSION}~$npmVersion~g Dockerfile.slim.tpl > $dockerfilePath/slim/Dockerfile
		fi

		# Only for intel edison
		if [ $device == "edison" ]; then
			sed -e s~#{FROM}~resin/$device-buildpack-deps:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g \
				-e s~#{NPM_VERSION}~$npmVersion~g Dockerfile.i386.edison.tpl > $dockerfilePath/Dockerfile

			sed -e s~#{FROM}~resin/$device-buildpack-deps:wheezy~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g \
				-e s~#{NPM_VERSION}~$npmVersion~g Dockerfile.i386.edison.tpl > $dockerfilePath/wheezy/Dockerfile

			sed -e s~#{FROM}~resin/$device-debian:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g \
				-e s~#{NPM_VERSION}~$npmVersion~g Dockerfile.i386.edison.slim.tpl > $dockerfilePath/slim/Dockerfile

		fi
	done
done

