#!/bin/bash
set -e

# comparing version: http://stackoverflow.com/questions/16989598/bash-comparing-version-numbers
function version_cmp() { test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" == "$1"; }

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6'
resinUrl="http://resin-packages.s3.amazonaws.com/node/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"
nodejsUrl="http://nodejs.org/dist/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"

#0.10.x
nodeVersions+=$(seq -f "0.10.%g" -s ' ' 0 41)
nodeVersions+=' '
#0.12.x
nodeVersions+=$(seq -f "0.12.%g" -s ' ' 0 9)
#4.x.x
nodeVersions+=' 4.0.0 4.1.0 4.1.1 4.1.2 4.2.0 4.2.1 4.2.2 4.2.3 4.2.4'
#5.x.x
nodeVersions+=' 5.0.0 5.2.0 5.3.0'

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
		echo $nodeVersion
		baseVersion=$(expr match "$nodeVersion" '\([0-9]*\.[0-9]*\)')

		# For armv7hf and armv6hf, if node version is less than 4.x.x (0.10.x 0.12.x) then that image will use binaries from resin, otherwise it will use binaries from official distribution.
		if [ $binary_arch == "armv7hf" ] || [ $binary_arch == "armv6hf" ]; then
			if version_cmp "$nodeVersion" "4"; then
				binary_url=$nodejsUrl
				if [ $binary_arch == "armv6hf" ]; then
					binary_arch='armv6l'
				else
					binary_arch='armv7l'
				fi
			fi
		fi

		dockerfilePath=$device/$baseVersion/$nodeVersion
		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~resin/$device-buildpack-deps:jessie~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.tpl > $dockerfilePath/Dockerfile

		mkdir -p $dockerfilePath/wheezy
		sed -e s~#{FROM}~resin/$device-buildpack-deps:wheezy~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.tpl > $dockerfilePath/wheezy/Dockerfile

		mkdir -p $dockerfilePath/onbuild
		sed -e s~#{FROM}~resin/$device-node:$nodeVersion~g Dockerfile.onbuild.tpl > $dockerfilePath/onbuild/Dockerfile
		mkdir -p $dockerfilePath/slim

		# Only for RPI1 device
		if [ $device == "raspberrypi" ]; then
			sed -e s~#{FROM}~resin/$device-systemd:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.slim.tpl > $dockerfilePath/slim/Dockerfile
		else
			sed -e s~#{FROM}~resin/$device-debian:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.slim.tpl > $dockerfilePath/slim/Dockerfile
		fi

		# Only for intel edison
		if [ $device == "edison" ]; then
			sed -e s~#{FROM}~resin/$device-buildpack-deps:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.i386.edison.tpl > $dockerfilePath/Dockerfile

			sed -e s~#{FROM}~resin/$device-buildpack-deps:wheezy~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.i386.edison.tpl > $dockerfilePath/wheezy/Dockerfile

			sed -e s~#{FROM}~resin/$device-debian:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.i386.edison.slim.tpl > $dockerfilePath/slim/Dockerfile
		fi
	done
done
