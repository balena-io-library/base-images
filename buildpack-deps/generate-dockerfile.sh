#!/bin/bash
set -e

devices='raspberry-pi raspberry-pi2 beaglebone-black intel-edison intel-nuc via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q ts7700 raspberry-pi3 artik5 artik10 beaglebone-green-wifi qemux86 qemux86-64 beaglebone-green cybertan-ze250 artik710 am571x-evm upboard kitra710'
fedora_devices=' raspberry-pi2 beaglebone-black via-vab820-quad zynq-xz702 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q raspberry-pi3 artik5 artik10 beaglebone-green-wifi beaglebone-green intel-nuc qemux86-64 artik710 am571x-evm kitra710 '
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
		if [ $device == 'raspberry-pi' ]; then
			sed -e s~#{FROM}~"resin/rpi-raspbian:$suite"~g Dockerfile.curl.tpl > $debian_dockerfilePath/curl/Dockerfile
			sed -e s~#{FROM}~"resin/$device-buildpack-deps:$suite-scm"~g Dockerfile.rpi.tpl > $debian_dockerfilePath/Dockerfile
		fi
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
		done
	fi

done