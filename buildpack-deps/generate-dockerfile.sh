#!/bin/bash
set -e

# List of devices
targets='raspberry-pi raspberry-pi2 beaglebone-black intel-edison intel-nuc via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q ts7700 raspberrypi3 artik5 artik10 beaglebone-green-wifi qemux86 qemux86-64 beaglebone-green cybertan-ze250 artik710 am571x-evm up-board kitra710 imx6ul-var-dart kitra520 jetson-tx2 iot2000 jetson-tx1 generic-armv7ahf generic-aarch64 bananapi-m1-plus'
# List of archs
targets+=' armv7hf armel i386 amd64 aarch64'
fedora_targets=' raspberry-pi2 beaglebone-black via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q raspberrypi3 artik5 artik10 beaglebone-green-wifi beaglebone-green intel-nuc qemux86-64 artik710 am571x-evm kitra710 up-board imx6ul-var-dart kitra520 jetson-tx2 jetson-tx1 armv7hf amd64 aarch64 generic-armv7ahf generic-aarch64 bananapi-m1-plus '
suites='jessie wheezy'
alpine_suites='edge 3.7'
fedora_suites='24 25'

for target in $targets; do

	# Debian
	for suite in $suites; do
		debian_dockerfilePath=$target/debian/$suite

		mkdir -p $debian_dockerfilePath
		sed -e s~#{FROM}~"resin/$target-buildpack-deps:$suite-scm"~g Dockerfile.tpl > $debian_dockerfilePath/Dockerfile

		mkdir -p $debian_dockerfilePath/curl
		sed -e s~#{FROM}~"resin/$target-debian:$suite"~g Dockerfile.curl.tpl > $debian_dockerfilePath/curl/Dockerfile

		mkdir -p $debian_dockerfilePath/scm
		sed -e s~#{FROM}~"resin/$target-buildpack-deps:$suite-curl"~g Dockerfile.scm.tpl > $debian_dockerfilePath/scm/Dockerfile

		# Only for rpi
		if [ $target == 'raspberry-pi' ]; then
			sed -e s~#{FROM}~"resin/rpi-raspbian:$suite"~g Dockerfile.curl.tpl > $debian_dockerfilePath/curl/Dockerfile
			sed -e s~#{FROM}~"resin/$target-buildpack-deps:$suite-scm"~g Dockerfile.rpi.tpl > $debian_dockerfilePath/Dockerfile
		fi
	done

	# Alpine

	# armel target not supported yet.
	if [ $target == "ts7700" ] || [ $target == "armel" ]; then
		continue
	fi

	if [ $target == "armv7hf" ]; then
		target='armhf'
	fi

	for alpine_suite in $alpine_suites; do
		dockerfilePath=$target/alpine/$alpine_suite

		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~"resin/$target-alpine-buildpack-deps:$alpine_suite-scm"~g Dockerfile.alpine.tpl > $dockerfilePath/Dockerfile

		mkdir -p $dockerfilePath/curl
		sed -e s~#{FROM}~"resin/$target-alpine:$alpine_suite"~g Dockerfile.alpine.curl.tpl > $dockerfilePath/curl/Dockerfile

		mkdir -p $dockerfilePath/scm
		sed -e s~#{FROM}~"resin/$target-alpine-buildpack-deps:$alpine_suite-curl"~g Dockerfile.alpine.scm.tpl > $dockerfilePath/scm/Dockerfile
	done

	# Fedora
	# Only support Armv7hf targets. Other targets will be supported later.

	if [ $target == "armhf" ]; then
		target='armv7hf'
	fi

	if [[ $fedora_targets == *" $target "* ]]; then
		for fedora_suite in $fedora_suites; do
			dockerfilePath=$target/fedora/$fedora_suite

			mkdir -p $dockerfilePath
			sed -e s~#{FROM}~"resin/$target-fedora-buildpack-deps:$fedora_suite-scm"~g Dockerfile.fedora.tpl > $dockerfilePath/Dockerfile

			mkdir -p $dockerfilePath/curl
			sed -e s~#{FROM}~"resin/$target-fedora:$fedora_suite"~g Dockerfile.fedora.curl.tpl > $dockerfilePath/curl/Dockerfile

			mkdir -p $dockerfilePath/scm
			sed -e s~#{FROM}~"resin/$target-fedora-buildpack-deps:$fedora_suite-curl"~g Dockerfile.fedora.scm.tpl > $dockerfilePath/scm/Dockerfile
		done
	fi

done
