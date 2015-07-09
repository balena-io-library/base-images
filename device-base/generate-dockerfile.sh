#!/bin/bash
set -e

devices='raspberrypi2 beaglebone edison'
suites='jessie wheezy'

for device in $devices; do

	case "$device" in
	'raspberrypi2')
		template='Dockerfile.armv7hf.rpi.tpl'
		baseImage='armv7hf-systemd'
	;;
	'beaglebone')
		template='Dockerfile.armv7hf.bbb.tpl'
		baseImage='armv7hf-systemd'
	;;
	'edison')
		template='Dockerfile.i386.edison.tpl'
		baseImage='i386-systemd'
	;;
	esac

	for suite in $suites; do		

		dockerfilePath="$device"
		mkdir -p $dockerfilePath/$suite
		sed -e s~#{FROM}~resin/$baseImage:$suite~g \
			-e s~#{SUITE}~$suite~g $template > $dockerfilePath/$suite/Dockerfile

	done

	# Only for armv7hf devices
	if [ $device == 'raspberrypi2' ] || [ $device == 'beaglebone' ]; then
		mkdir -p $dockerfilePath/sid
		sed -e s~#{FROM}~resin/$baseImage:sid~g \
			-e s~#{SUITE}~sid~g $template > $dockerfilePath/sid/Dockerfile		
	fi

done

