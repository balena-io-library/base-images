#!/bin/bash
set -e

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 ts7700 raspberrypi3 artik5 artik10 beaglebone-green-wifi'
suites='jessie wheezy'
alpine_suites='3.3 3.4 edge'

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
done
