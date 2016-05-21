#!/bin/bash
set -e

# comparing version: http://stackoverflow.com/questions/16989598/bash-comparing-version-numbers
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" == "$1"; }

# extract checksum for node binary
function extract_checksum()
{
	# $1: binary type, 0: in-house, 1: official.
	# $2: node version

	if [ $1 -eq 0 ]; then
		checksum=$(grep " node-v$2-linux-$binary_arch.tar.gz" SHASUMS256.txt)
	else
		curl -SLO "https://nodejs.org/dist/v$2/SHASUMS256.txt.asc" \
		&& gpg --verify SHASUMS256.txt.asc \
		&& checksum=$(grep " node-v$2-linux-$binary_arch.tar.gz\$" SHASUMS256.txt.asc) \
		&& rm -f SHASUMS256.txt.asc
	fi
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

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 ts7700 raspberrypi3 artik5 artik10'
nodeVersions='0.10.22 0.10.45 0.12.14 4.4.4 5.11.1 6.2.0'
defaultVersion='0.10.22'
resinUrl="http://resin-packages.s3.amazonaws.com/node/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"
nodejsUrl="http://nodejs.org/dist/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"

for device in $devices; do
	for nodeVersion in $nodeVersions; do
		case "$device" in
		'raspberrypi')
			binary_url=$resinUrl
			binary_arch='armv6hf'
		;;
		'raspberrypi2')
			binary_url=$resinUrl
			binary_arch='armv7hf'
		;;
		'raspberrypi3')
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
		'ts7700')
			binary_url=$resinUrl
			binary_arch='armel'
		;;
		'artik5')
			binary_url=$resinUrl
			binary_arch='armv7hf'
		;;
		'artik10')
			binary_url=$resinUrl
			binary_arch='armv7hf'
		;;
		esac
		if [ $nodeVersion == $defaultVersion ]; then
			baseVersion='default'
		else
			baseVersion=$(expr match "$nodeVersion" '\([0-9]*\.[0-9]*\)')
		fi

		# Debian.
		# For armv7hf and armv6hf, if node version is greater or equal than 4.x.x then that image will use binaries from official distribution, otherwise it will use binaries from resin.
		if [ $binary_arch == "armv7hf" ] || [ $binary_arch == "armv6hf" ]; then
			if version_ge "$nodeVersion" "4"; then
				binary_url=$nodejsUrl
				if [ $binary_arch == "armv6hf" ]; then
					binary_arch='armv6l'
				else
					binary_arch='armv7l'
				fi
			fi
		fi

		if [ $binary_arch == "armel" ] && [ $baseVersion == "6.2"  ]; then
			# Node v6.2.0 not available for armel yet.
			continue
		fi

		# Extract checksum
		if [ $binary_url == "$nodejsUrl" ]; then
			extract_checksum 1 $nodeVersion
		else
			extract_checksum 0 $nodeVersion
		fi

		debian_dockerfilePath=$device/debian/$baseVersion
		mkdir -p $debian_dockerfilePath
		sed -e s~#{FROM}~resin/$device-buildpack-deps:jessie~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.tpl > $debian_dockerfilePath/Dockerfile

		mkdir -p $debian_dockerfilePath/wheezy
		sed -e s~#{FROM}~resin/$device-buildpack-deps:wheezy~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.tpl > $debian_dockerfilePath/wheezy/Dockerfile

		mkdir -p $debian_dockerfilePath/onbuild
		sed -e s~#{FROM}~resin/$device-node:$nodeVersion~g Dockerfile.onbuild.tpl > $debian_dockerfilePath/onbuild/Dockerfile
		mkdir -p $debian_dockerfilePath/slim

		# Only for RPI1 device
		if [ $device == "raspberrypi" ]; then
			sed -e s~#{FROM}~resin/$device-systemd:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
		else
			sed -e s~#{FROM}~resin/$device-debian:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
		fi

		# Only for intel edison
		if [ $device == "edison" ]; then
			sed -e s~#{FROM}~resin/$device-buildpack-deps:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.i386.edison.tpl > $debian_dockerfilePath/Dockerfile

			sed -e s~#{FROM}~resin/$device-buildpack-deps:wheezy~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.i386.edison.tpl > $debian_dockerfilePath/wheezy/Dockerfile

			sed -e s~#{FROM}~resin/$device-debian:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.i386.edison.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
		fi

		# Alpine
		case "$binary_arch" in
		'x64')
			binary_arch='alpine-amd64'
			binary_url=$resinUrl
		;;
		'x86')
			binary_arch='alpine-i386'
			binary_url=$resinUrl
		;;
		'armel')
			# armel not supported yet.
			continue
		;;
		*)
			binary_arch='alpine-armhf'
			binary_url=$resinUrl
		;;
		esac

		# Node 0.12.x are not supported atm.
		if [ $baseVersion == '0.12' ]; then
			continue
		fi
		extract_checksum 0 $nodeVersion

		alpine_dockerfilePath=$device/alpine/$baseVersion

		mkdir -p $alpine_dockerfilePath
		sed -e s~#{FROM}~resin/$device-alpine-buildpack-deps:latest~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.alpine.tpl > $alpine_dockerfilePath/Dockerfile

		mkdir -p $alpine_dockerfilePath/slim
		sed -e s~#{FROM}~resin/$device-alpine:latest~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.alpine.slim.tpl > $alpine_dockerfilePath/slim/Dockerfile

		mkdir -p $alpine_dockerfilePath/onbuild
		sed -e s~#{FROM}~resin/$device-alpine-node:$nodeVersion~g Dockerfile.onbuild.tpl > $alpine_dockerfilePath/onbuild/Dockerfile

		mkdir -p $alpine_dockerfilePath/edge
		sed -e s~#{FROM}~resin/$device-alpine-buildpack-deps:edge~g \
			-e s~#{BINARY_URL}~$binary_url~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binary_arch~g Dockerfile.alpine.tpl > $alpine_dockerfilePath/edge/Dockerfile
	done
done

