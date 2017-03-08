#!/bin/bash
set -e

# $1: path
# $2: variants
set_onbuild_warning() {
	for va in $2; do
		if [ $va == 'base' ]; then
			tmp_path=$1
		else
			tmp_path="$1/$va"
		fi
		if [ -f "$tmp_path/Dockerfile" ]; then
			echo "ONBUILD RUN echo 'This repository is deprecated. Please check https://docs.resin.io/runtime/resin-base-images/ for information about Resin docker images.' " >> $tmp_path/Dockerfile
		fi
	done
	
}

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 ts7700 raspberrypi3 artik5 artik10 beaglebone-green-wifi qemux86 qemux86-64 beaglebone-green intel-quark artik710 am57xx-evm up-board'
fedora_devices=' raspberrypi2 beaglebone vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 raspberrypi3 artik5 artik10 beaglebone-green-wifi beaglebone-green nuc qemux86-64 artik710 am57xx-evm '
suites='jessie wheezy'
alpine_suites='3.3 3.4 3.5 edge'
fedora_suites='23 24'

for device in $devices; do

	# Debian
	for suite in $suites; do
		debian_dockerfilePath=$device/debian/$suite

		mkdir -p $debian_dockerfilePath
		sed -e s~#{FROM}~"resin/$device-buildpack-deps:$suite-scm"~g Dockerfile.tpl > $debian_dockerfilePath/Dockerfile

		mkdir -p $debian_dockerfilePath/curl
		sed -e s~#{FROM}~"resin/$device-debian:$suite"~g Dockerfile.curl.tpl > $debian_dockerfilePath/curl/Dockerfile

		mkdir -p $debian_dockerfilePath/scm
		sed -e s~#{FROM}~"resin/$device-buildpack-deps:$suite-curl"~g Dockerfile.scm.tpl > $debian_dockerfilePath/scm/Dockerfile

		# Only for rpi
		if [ $device == 'raspberrypi' ]; then
			sed -e s~#{FROM}~"resin/rpi-raspbian:$suite"~g Dockerfile.curl.tpl > $debian_dockerfilePath/curl/Dockerfile
			sed -e s~#{FROM}~"resin/$device-buildpack-deps:$suite-scm"~g Dockerfile.rpi.tpl > $debian_dockerfilePath/Dockerfile
		fi

		set_onbuild_warning "$debian_dockerfilePath" "base curl scm"

	done

	# Alpine

	# armel device not supported yet.
	if [ $device == "ts7700" ]; then
		continue
	fi

	for alpine_suite in $alpine_suites; do
		dockerfilePath=$device/alpine/$alpine_suite

		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~"resin/$device-alpine-buildpack-deps:$alpine_suite-scm"~g Dockerfile.alpine.tpl > $dockerfilePath/Dockerfile

		mkdir -p $dockerfilePath/curl
		sed -e s~#{FROM}~"resin/$device-alpine:$alpine_suite"~g Dockerfile.alpine.curl.tpl > $dockerfilePath/curl/Dockerfile

		mkdir -p $dockerfilePath/scm
		sed -e s~#{FROM}~"resin/$device-alpine-buildpack-deps:$alpine_suite-curl"~g Dockerfile.alpine.scm.tpl > $dockerfilePath/scm/Dockerfile

		set_onbuild_warning "$dockerfilePath" "base curl scm"
	done

	# Fedora
	# Only support Armv7hf devices. Other devices will be supported later.

	if [[ $fedora_devices == *" $device "* ]]; then
		for fedora_suite in $fedora_suites; do
			dockerfilePath=$device/fedora/$fedora_suite

			mkdir -p $dockerfilePath
			sed -e s~#{FROM}~"resin/$device-fedora-buildpack-deps:$fedora_suite-scm"~g Dockerfile.fedora.tpl > $dockerfilePath/Dockerfile

			mkdir -p $dockerfilePath/curl
			sed -e s~#{FROM}~"resin/$device-fedora:$fedora_suite"~g Dockerfile.fedora.curl.tpl > $dockerfilePath/curl/Dockerfile

			mkdir -p $dockerfilePath/scm
			sed -e s~#{FROM}~"resin/$device-fedora-buildpack-deps:$fedora_suite-curl"~g Dockerfile.fedora.scm.tpl > $dockerfilePath/scm/Dockerfile

			set_onbuild_warning "$dockerfilePath" "base curl scm"
		done
	fi

done