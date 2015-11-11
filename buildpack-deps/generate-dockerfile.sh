#!/bin/bash
set -e

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6'
suites='jessie wheezy'

for device in $devices; do

	if [ $device == 'raspberrypi' ]; then
		baseImage="$device-systemd"
	else
		baseImage="$device"
	fi

	for suite in $suites; do
		dockerfilePath=$device/$suite

		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~resin/$baseImage-buildpack-deps:$suite-scm~g Dockerfile.tpl > $dockerfilePath/Dockerfile

		mkdir -p $dockerfilePath/curl
		sed -e s~#{FROM}~resin/$baseImage-debian:$suite~g Dockerfile.curl.tpl > $dockerfilePath/curl/Dockerfile

		mkdir -p $dockerfilePath/scm
		sed -e s~#{FROM}~resin/$baseImage-buildpack-deps:$suite-curl~g Dockerfile.scm.tpl > $dockerfilePath/scm/Dockerfile

		# Only for rpi
		if [ $device == 'raspberrypi' ]; then
			sed -e s~#{FROM}~resin/raspberrypi-buildpack-deps:$suite-scm~g Dockerfile.rpi.tpl > $dockerfilePath/Dockerfile
			sed -e s~#{FROM}~resin/raspberrypi-buildpack-deps:$suite-curl~g Dockerfile.scm.tpl > $dockerfilePath/scm/Dockerfile
			sed -e s~#{FROM}~resin/$baseImage:$suite~g Dockerfile.curl.tpl > $dockerfilePath/curl/Dockerfile
		fi
	done
done
