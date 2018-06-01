#!/bin/bash
set -e

# comparing version: http://stackoverflow.com/questions/16989598/bash-comparing-version-numbers
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" == "$1"; }
function version_le() { test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" != "$1"; }

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
56730D5401028683275BD23C23EFEFE93C4CFFFE \
77984A986EBC2AA786BC0F66B01FBB92821C587A \
; do \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
done

# List of devices
targets='raspberry-pi raspberry-pi2 beaglebone-black intel-edison intel-nuc via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q ts7700 raspberrypi3 artik5 artik10 beaglebone-green-wifi qemux86 qemux86-64 beaglebone-green cybertan-ze250 artik710 am571x-evm up-board kitra710 imx6ul-var-dart kitra520 jetson-tx2 jetson-tx1 iot2000 generic-aarch64 generic-armv7ahf bananapi-m1-plus orangepi-plus2 fincm3 artik533s artik530'
# List of archs
targets+=' armv7hf armel i386 amd64 aarch64'
fedora_targets=' raspberry-pi2 beaglebone-black via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q raspberrypi3 artik5 artik10 beaglebone-green-wifi beaglebone-green intel-nuc qemux86-64 artik710 am571x-evm kitra710 up-board imx6ul-var-dart kitra520 jetson-tx2 jetson-tx1 armv7hf amd64 aarch64 generic-aarch64 generic-armv7ahf bananapi-m1-plus orangepi-plus2 fincm3 artik533s artik530 '
nodeVersions='0.10.22 0.10.48 0.12.18 5.12.0 7.10.1 9.11.1 8.11.2 6.14.2 4.9.1 10.1.0'
defaultVersion='0.10.22'
yarnVersion='1.5.1'
resinUrl="http://resin-packages.s3.amazonaws.com/node/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"
nodejsUrl="http://nodejs.org/dist/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"

for target in $targets; do
	for nodeVersion in $nodeVersions; do
		case "$target" in
		'armv7hf'|'generic-armv7ahf'|'bananapi-m1-plus'|'orangepi-plus2')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'armel')
			binaryUrl=$resinUrl
			binaryArch='armel'
		;;
		'i386')
			binaryUrl=$nodejsUrl
			binaryArch='x86'
		;;
		'amd64')
			binaryUrl=$nodejsUrl
			binaryArch='x64'
		;;
		'aarch64')
			binaryUrl=$nodejsUrl
			binaryArch='arm64'
		;;
		'raspberry-pi')
			binaryUrl=$resinUrl
			binaryArch='armv6hf'
		;;
		'raspberry-pi2')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'raspberrypi3'|'fincm3')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'beaglebone-black')
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
		'intel-edison')
			binaryUrl=$nodejsUrl
			binaryArch='x86'
		;;
		'qemux86')
			binaryUrl=$nodejsUrl
			binaryArch='x86'
		;;
		'cybertan-ze250')
			binaryUrl=$resinUrl
			binaryArch='i386'
		;;
		'iot2000')
			binaryUrl=$resinUrl
			binaryArch='i386'
		;;
		'intel-nuc')
			binaryUrl=$nodejsUrl
			binaryArch='x64'
		;;
		'qemux86-64')
			binaryUrl=$nodejsUrl
			binaryArch='x64'
		;;
		'up-board')
			binaryUrl=$nodejsUrl
			binaryArch='x64'
		;;
		'via-vab820-quad')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'zynq-xz702')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'odroid-c1')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'odroid-xu4')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'parallella')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'nitrogen6x')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'hummingboard')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'ts4900')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'colibri-imx6dl')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'apalis-imx6q')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'am571x-evm')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'ts7700')
			binaryUrl=$resinUrl
			binaryArch='armel'
		;;
		'artik5'|'artik533s'|'artik530')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'artik10')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'kitra520')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'imx6ul-var-dart')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'ccon-01')
			binaryUrl=$resinUrl
			binaryArch='armv7hf'
		;;
		'jetson-tx2'|'jetson-tx1'|'kitra710'|'artik710'|'generic-aarch64')
			binaryUrl=$nodejsUrl
			binaryArch='arm64'
		;;
		esac
		if [ $nodeVersion == $defaultVersion ]; then
			baseVersion='default'
		else
			baseVersion=$(expr match "$nodeVersion" '\([0-9]*\.[0-9]*\)')
		fi

		if [ $baseVersion != '0.10' ] && [ $binaryArch == "armel" ]; then
			continue
		fi

		# we don't have Node v8.0.0 for x87 yet.
		if (version_ge "$nodeVersion" "8") && ([ $target == "cybertan-ze250" ] || [ $target == "iot2000" ]); then
			continue
		fi

		# No Node v0.10.x and v0.12.x for aarch64.
		if (version_le "$nodeVersion" "4") && [ $binaryArch="arm64" ]; then
			continue
		fi

		# Debian.
		# For armv6hf, if node version is greater or equal than 4.x.x then that image will use binaries from official distribution, otherwise it will use binaries from resin.
		if [ $binaryArch == "armv6hf" ]; then
			if version_ge "$nodeVersion" "4"; then
				binaryUrl=$nodejsUrl
				binaryArch='armv6l'
			fi
		fi

		# Extract checksum
		if [ $binaryUrl == "$nodejsUrl" ]; then
			extract_checksum 1 $nodeVersion "checksum"
		else
			extract_checksum 0 $nodeVersion "checksum"
		fi

		debian_dockerfilePath=$target/debian/$baseVersion
		mkdir -p $debian_dockerfilePath
		sed -e s~#{FROM}~resin/$target-buildpack-deps:jessie~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{YARN_VERSION}~$yarnVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $debian_dockerfilePath/Dockerfile

		mkdir -p $debian_dockerfilePath/stretch
		sed -e s~#{FROM}~resin/$target-buildpack-deps:stretch~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{YARN_VERSION}~$yarnVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $debian_dockerfilePath/stretch/Dockerfile

		mkdir -p $debian_dockerfilePath/onbuild
		sed -e s~#{FROM}~resin/$target-node:$nodeVersion~g Dockerfile.onbuild.tpl > $debian_dockerfilePath/onbuild/Dockerfile
		mkdir -p $debian_dockerfilePath/slim

		# Only for RPI1 target
		if [ $target == "raspberry-pi" ]; then
			sed -e s~#{FROM}~resin/rpi-raspbian:jessie~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{YARN_VERSION}~$yarnVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
		else
			sed -e s~#{FROM}~resin/$target-debian:jessie~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{YARN_VERSION}~$yarnVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
		fi

		# Only for intel intel-edison
		if [ $target == "intel-edison" ]; then
			if ! version_ge "$nodeVersion" "7"; then
				# mraa doesn't support Node.js 7.0.0+ so we will use generic template for them.
				sed -e s~#{FROM}~resin/$target-buildpack-deps:jessie~g \
					-e s~#{BINARY_URL}~$binaryUrl~g \
					-e s~#{NODE_VERSION}~$nodeVersion~g \
					-e s~#{YARN_VERSION}~$yarnVersion~g \
					-e s~#{CHECKSUM}~"$checksum"~g \
					-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.i386.edison.tpl > $debian_dockerfilePath/Dockerfile

				sed -e s~#{FROM}~resin/$target-buildpack-deps:stretch~g \
					-e s~#{BINARY_URL}~$binaryUrl~g \
					-e s~#{NODE_VERSION}~$nodeVersion~g \
					-e s~#{YARN_VERSION}~$yarnVersion~g \
					-e s~#{CHECKSUM}~"$checksum"~g \
					-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.i386.edison.tpl > $debian_dockerfilePath/stretch/Dockerfile

				sed -e s~#{FROM}~resin/$target-debian:jessie~g \
					-e s~#{BINARY_URL}~$binaryUrl~g \
					-e s~#{NODE_VERSION}~$nodeVersion~g \
					-e s~#{YARN_VERSION}~$yarnVersion~g \
					-e s~#{CHECKSUM}~"$checksum"~g \
					-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.i386.edison.slim.tpl > $debian_dockerfilePath/slim/Dockerfile
			fi
		fi

		# Fedora
		if [[ $fedora_targets == *" $target "* ]]; then
			fedora_dockerfilePath=$target/fedora/$baseVersion

			mkdir -p $fedora_dockerfilePath
			sed -e s~#{FROM}~resin/$target-fedora-buildpack-deps:latest~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{YARN_VERSION}~$yarnVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $fedora_dockerfilePath/Dockerfile

			mkdir -p $fedora_dockerfilePath/25
			sed -e s~#{FROM}~resin/$target-fedora-buildpack-deps:25~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{YARN_VERSION}~$yarnVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $fedora_dockerfilePath/25/Dockerfile

			mkdir -p $fedora_dockerfilePath/onbuild
			sed -e s~#{FROM}~resin/$target-fedora-node:$nodeVersion~g Dockerfile.onbuild.tpl > $fedora_dockerfilePath/onbuild/Dockerfile

			mkdir -p $fedora_dockerfilePath/slim
			sed -e s~#{FROM}~resin/$target-fedora:latest~g \
				-e s~#{BINARY_URL}~$binaryUrl~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{YARN_VERSION}~$yarnVersion~g \
				-e s~#{CHECKSUM}~"$checksum"~g \
				-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.tpl > $fedora_dockerfilePath/slim/Dockerfile
		fi

		# Alpine
		case "$binaryArch" in
		'x64')
			binaryArch='alpine-amd64'
			binaryUrl=$resinUrl
		;;
		'i386'|'x86')
			binaryArch='alpine-i386'
			binaryUrl=$resinUrl
		;;
		'arm64')
			binaryArch='alpine-aarch64'
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

		if [ $target == "armv7hf" ]; then
			target='armhf'
		fi

		alpine_dockerfilePath=$target/alpine/$baseVersion

		mkdir -p $alpine_dockerfilePath
		sed -e s~#{FROM}~resin/$target-alpine-buildpack-deps:latest~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{YARN_VERSION}~$yarnVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.alpine.tpl > $alpine_dockerfilePath/Dockerfile

		mkdir -p $alpine_dockerfilePath/slim
		sed -e s~#{FROM}~resin/$target-alpine:latest~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{YARN_VERSION}~$yarnVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.alpine.slim.tpl > $alpine_dockerfilePath/slim/Dockerfile

		mkdir -p $alpine_dockerfilePath/onbuild
		sed -e s~#{FROM}~resin/$target-alpine-node:$nodeVersion~g Dockerfile.onbuild.tpl > $alpine_dockerfilePath/onbuild/Dockerfile

		mkdir -p $alpine_dockerfilePath/edge
		sed -e s~#{FROM}~resin/$target-alpine-buildpack-deps:edge~g \
			-e s~#{BINARY_URL}~$binaryUrl~g \
			-e s~#{NODE_VERSION}~$nodeVersion~g \
			-e s~#{YARN_VERSION}~$yarnVersion~g \
			-e s~#{CHECKSUM}~"$checksum"~g \
			-e s~#{TARGET_ARCH}~$binaryArch~g Dockerfile.alpine.tpl > $alpine_dockerfilePath/edge/Dockerfile
	done
done
