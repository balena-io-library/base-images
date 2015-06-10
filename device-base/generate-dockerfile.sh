#!/bin/bash
set -e

devices='raspberry-pi2 beaglebone-black intel-edison'
suites='jessie wheezy'

for device in $devices; do

	case "$device" in
	'raspberry-pi2')
		template='Dockerfile.armv7hf.rpi.tpl'
		baseImage='armv7hf-systemd'
	;;
	'beaglebone-black')
		template='Dockerfile.armv7hf.bbb.tpl'
		baseImage='armv7hf-systemd'
	;;
	'intel-edison')
		template='Dockerfile.i386.edison.tpl'
		baseImage='i386-systemd'
	;;
	esac

	for suite in $suites; do		

		dockerfilePath="$device"
		mkdir -p $dockerfilePath/$suite
		sed -e s~#{FROM}~resin/$baseImage:$suite~g $template > $dockerfilePath/$suite/Dockerfile

	done

	# Only for armv7hf devices
	if [ $device == 'raspberry-pi2' ] || [ $device == 'beaglebone-black' ]; then
		mkdir -p $dockerfilePath/sid
		sed -e s~#{FROM}~resin/$baseImage:sid~g $template > $dockerfilePath/sid/Dockerfile		
	fi

done

