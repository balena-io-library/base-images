#!/bin/bash
set -e

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 ts7700 raspberrypi3'
suites='jessie wheezy alpine'

for device in $devices; do

	for suite in $suites; do
		dockerfilePath=$device/$suite

		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~"resin/$device-buildpack-deps:$suite-scm"~g Dockerfile.tpl > $dockerfilePath/Dockerfile

		mkdir -p $dockerfilePath/curl
		sed -e s~#{FROM}~"resin/$device-debian:$suite"~g Dockerfile.curl.tpl > $dockerfilePath/curl/Dockerfile

		mkdir -p $dockerfilePath/scm
		sed -e s~#{FROM}~"resin/$device-buildpack-deps:$suite-curl"~g Dockerfile.scm.tpl > $dockerfilePath/scm/Dockerfile

		if [ $suite == 'alpine' ]; then
			sed -e s~#{FROM}~"resin/$device-alpine-buildpack-deps:scm"~g Dockerfile.alpine.tpl > $dockerfilePath/Dockerfile
			sed -e s~#{FROM}~"resin/$device-alpine:latest"~g Dockerfile.alpine.curl.tpl > $dockerfilePath/curl/Dockerfile
			sed -e s~#{FROM}~"resin/$device-alpine-buildpack-deps:curl"~g Dockerfile.alpine.scm.tpl > $dockerfilePath/scm/Dockerfile
		fi

		# Only for rpi
		if [ $device == 'raspberrypi' ]; then
			if [ $suite != 'alpine' ]; then
				sed -e s~#{FROM}~"resin/raspberrypi-systemd:$suite"~g Dockerfile.curl.tpl > $dockerfilePath/curl/Dockerfile
			fi
		fi
	done
done
