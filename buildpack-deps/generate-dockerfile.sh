#!/bin/bash
set -e

devices='raspberry-pi raspberry-pi2 beaglebone-black intel-edison'
suites='jessie wheezy'

for device in $devices; do

	if [ $device == 'raspberry-pi' ]; then
		baseImage="$device-systemd"
	else
		baseImage="$device"
	fi

	for suite in $suites; do
		dockerfilePath=$device/$suite

		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~resin/$baseImage-buildpack-deps:$suite-scm~g Dockerfile.tpl > $dockerfilePath/Dockerfile

		mkdir -p $dockerfilePath/curl
		sed -e s~#{FROM}~resin/$baseImage:$suite~g Dockerfile.curl.tpl > $dockerfilePath/curl/Dockerfile

		mkdir -p $dockerfilePath/scm
		sed -e s~#{FROM}~resin/$baseImage-buildpack-deps:$suite-curl~g Dockerfile.scm.tpl > $dockerfilePath/scm/Dockerfile

		# Only for rpi
		if [ $device == 'raspberry-pi' ]; then
			sed -e s~#{FROM}~resin/raspberry-pi-buildpack-deps:$suite-scm~g Dockerfile.rpi.tpl > $dockerfilePath/Dockerfile
			sed -e s~#{FROM}~resin/raspberry-pi-buildpack-deps:$suite-curl~g Dockerfile.scm.tpl > $dockerfilePath/scm/Dockerfile
			sed -e s~#{FROM}~resin/$baseImage:$suite~g Dockerfile.curl.tpl > $dockerfilePath/curl/Dockerfile
		fi

	done

	# Only for armv7hf devices
	if [ $device == 'raspberry-pi2' ] || [ $device == 'beaglebone-black' ]; then
		suite='sid'
		dockerfilePath=$device/$suite
		
		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~resin/$baseImage-buildpack-deps:$suite-scm~g Dockerfile.tpl > $dockerfilePath/Dockerfile

		mkdir -p $dockerfilePath/curl
		sed -e s~#{FROM}~resin/$baseImage:$suite~g Dockerfile.curl.tpl > $dockerfilePath/curl/Dockerfile

		mkdir -p $dockerfilePath/scm
		sed -e s~#{FROM}~resin/$baseImage-buildpack-deps:$suite-curl~g Dockerfile.scm.tpl > $dockerfilePath/scm/Dockerfile
	fi	

done
