#!/bin/bash
set -e

# comparing version: http://stackoverflow.com/questions/16989598/bash-comparing-version-numbers
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" == "$1"; }

# extract checksum for node binary
function extract_checksum()
{
	# $1: binary type, 0: in-house, 1: official.
	# $2: node version
	# $3: variable name for result

	local __resultVar=$3

	if [ $1 -eq 0 ]; then
		local __checksum=$(grep " node-v$2-linux-$binaryArch.tar.gz" SHASUMS256.txt)
	else
		curl -SLO "https://nodejs.org/dist/v$2/SHASUMS256.txt.asc" \
		&& gpg --verify SHASUMS256.txt.asc \
		&& local __checksum=$(grep " node-v$2-linux-$binaryArch.tar.gz\$" SHASUMS256.txt.asc) \
		&& rm -f SHASUMS256.txt.asc
	fi
	eval $__resultVar="'$__checksum'"
}

# gpg keys listed at https://github.com/nodejs/node
for key in \
9554F04D7259F04124DE6B476D5A82AC7E37093B \
94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
FD3A5288F042B6850C66B31F09FE44734EB7990E \
71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
B9AE9905FFD7803F25714661B63B535A4C206CA9 \
C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
7937DFD2AB06298B2293C3187D33FF9D0246406D \
114F43EE0176B71C7BC219DD50A3051F888C628D \
; do \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
done

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 ts7700 raspberrypi3 artik5 artik10 beaglebone-green-wifi qemux86 qemux86-64 beaglebone-green'
armv7hf_devices=' raspberrypi2 beaglebone vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 raspberrypi3 artik5 artik10 beaglebone-green-wifi beaglebone-green '
nodeVersions='0.10.22 0.10.46 0.12.15 4.5.0 5.12.0 6.6.0'
defaultVersion='0.10.22'
resinUrl="http://resin-packages.s3.amazonaws.com/node/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"
nodejsUrl="http://nodejs.org/dist/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"

for device in $devices; do
	for nodeVersion in $nodeVersions; do
		case "$device" in
		'raspberrypi')
			binaryUrl=$resinUrl
			binaryArch='armv6hf'
		;;
		'raspberrypi2')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'raspberrypi3')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'beaglebone')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'beaglebone-green-wifi')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'beaglebone-green')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'edison')
			binaryUrl=$nodejsUrl
			binaryArch='x86'
		;;
		'qemux86')
			binaryUrl=$nodejsUrl
			binaryArch='x86'
		;;
		'nuc')
			binaryUrl=$nodejsUrl
			binaryArch='x64'
		;;
		'qemux86-64')
			binaryUrl=$nodejsUrl
			binaryArch='x64'
		;;
		'vab820-quad')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'zc702-zynq7')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'odroid-c1')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'odroid-ux3')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'parallella-hdmi-resin')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'nitrogen6x')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'cubox-i')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'ts4900')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'colibri-imx6')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'apalis-imx6')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'ts7700')
			binaryUrl=$resinUrl
			binaryArch='armel'
		;;
		'artik5')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'artik10')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		esac
		if [ $nodeVersion == $defaultVersion ]; then
			baseVersion='default'
		else
			baseVersion=$(expr match "$nodeVersion" '\([0-9]*\.[0-9]*\)')
		fi

		# Debian.
		# For armv7hf and armv6hf, if node version is greater or equal than 4.x.x then that image will use binaries from official distribution, otherwise it will use binaries from resin.
		if [ $binaryArch == "armv7hf" ] || [ $binaryArch == "armv6hf" ]; then
			if version_ge "$nodeVersion" "4"; then
				binaryUrl=$nodejsUrl
				if [ $binaryArch == "armv6hf" ]; then
					binaryArch='armv6l'
				else
					binaryArch='armv7l'
				fi
			fi
		fi

		# Extract checksum
		if [ $binaryUrl == "$nodejsUrl" ]; then
			extract_checksum 1 $nodeVersion "checksum"
		else
			extract_checksum 0 $nodeVersion "checksum"
		fi

		# Set v6.3.1 as the latest node version for debian wheezy (https://github.com/resin-io-library/base-images/issues/177)
		if version_ge "$nodeVersion" "6"; then
			wheezyNodeVersion='6.3.1'
			extract_checksum 1 $wheezyNodeVersion "wheezyChecksum"
		else
			wheezyNodeVersion=$nodeVersion
			wheezyChecksum=$checksum
		fi


		debian_dockerfilePath=$device/debian/$baseVersion
		mkdir -p $debian_dockerfilePath
		sed -e s~#{FROM}~resin/$device-buildpack-deps:jessie~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $debian_dockerfilePath/Dockerfile

		mkdir -p $device/debian/6.3/wheezy
		sed -e s~#{FROM}~resin/$device-buildpack-deps:wheezy~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$wheezyNodeVersion~g \
			-e s~#{CHECKSUM}~"$wheezyChecksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $device/debian/6.3/wheezy/Dockerfile

		mkdir -p $debian_dockerfilePath/onbuild
		sed -e s~#{FROM}~resin/$device-node:$nodeVersion~g Dockerfile.onbuild.tpl > $debian_dockerfilePath/onbuild/Dockerfile
		mkdir -p $debian_dockerfilePath/slim

		# Only for RPI1 device
		if [ $device == "raspberrypi" ]; then
			sed -e s~#{FROM}~resin/rpi-raspbian:jessie~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
		else
			sed -e s~#{FROM}~resin/$device-debian:jessie~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
		fi

		# Only for intel edison
		if [ $device == "edison" ] || [ $device == "qemux86" ]; then
			sed -e s~#{FROM}~resin/$device-buildpack-deps:jessie~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.i386.edison.tpl > $debian_dockerfilePath/Dockerfile

			sed -e s~#{FROM}~resin/$device-buildpack-deps:wheezy~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$wheezyNodeVersion~g \
				-e s~#{CHECKSUM}~"$wheezyChecksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.i386.edison.tpl > $device/debian/6.3/wheezy/Dockerfile

			sed -e s~#{FROM}~resin/$device-debian:jessie~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.i386.edison.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
		fi

		# Fedora
		if [[ $armv7hf_devices == *" $device "* ]]; then
			fedora_dockerfilePath=$device/fedora/$baseVersion

			mkdir -p $fedora_dockerfilePath
			sed -e s~#{FROM}~resin/$device-fedora-buildpack-deps:latest~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $fedora_dockerfilePath/Dockerfile

			mkdir -p $fedora_dockerfilePath/23
			sed -e s~#{FROM}~resin/$device-fedora-buildpack-deps:23~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $fedora_dockerfilePath/23/Dockerfile

			mkdir -p $fedora_dockerfilePath/onbuild
			sed -e s~#{FROM}~resin/$device-fedora-node:$nodeVersion~g Dockerfile.onbuild.tpl > $fedora_dockerfilePath/onbuild/Dockerfile

			mkdir -p $fedora_dockerfilePath/slim
			sed -e s~#{FROM}~resin/$device-fedora:latest~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $fedora_dockerfilePath/slim/Dockerfile
		fi

		# Alpine
		case "$binaryArch" in
		'x64')
			binaryArch='alpine-amd64'
			binaryUrl=$resinUrl
		;;
		'x86')
			binaryArch='alpine-i386'
			binaryUrl=$resinUrl
		;;
		'armel')
			# armel not supported yet.
			continue
		;;
		*)
			binaryArch='alpine-armhf'
			binaryUrl=$resinUrl
		;;
		esac

		# Node 0.12.x are not supported atm.
		if [ $baseVersion == '0.12' ]; then
			continue
		fi
		extract_checksum 0 $nodeVersion "checksum"

		alpine_dockerfilePath=$device/alpine/$baseVersion

		mkdir -p $alpine_dockerfilePath
		sed -e s~#{FROM}~resin/$device-alpine-buildpack-deps:latest~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.alpine.tpl > $alpine_dockerfilePath/Dockerfile

		mkdir -p $alpine_dockerfilePath/slim
		sed -e s~#{FROM}~resin/$device-alpine:latest~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.alpine.slim.tpl > $alpine_dockerfilePath/slim/Dockerfile

		mkdir -p $alpine_dockerfilePath/onbuild
		sed -e s~#{FROM}~resin/$device-alpine-node:$nodeVersion~g Dockerfile.onbuild.tpl > $alpine_dockerfilePath/onbuild/Dockerfile

		mkdir -p $alpine_dockerfilePath/edge
		sed -e s~#{FROM}~resin/$device-alpine-buildpack-deps:edge~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.alpine.tpl > $alpine_dockerfilePath/edge/Dockerfile
	done
done
