#!/bin/bash
set -e

devices='raspberry-pi raspberry-pi2 beaglebone-black intel-edison'
suites='jessie wheezy'

for device in $devices; do
	if [ $device == 'intel-edison' ]; then
		template='Dockerfile.i386.edison.tpl'
	else
		template='Dockerfile.tpl'
	fi
	for suite in $suites; do
		dockerfilePath="$device"
		mkdir -p $dockerfilePath/$suite
		sed -e s~#{FROM}~resin/$device-buildpack-deps:$suite~g $template > $dockerfilePath/$suite/Dockerfile
 
		# Only for ARMv7 device
		if [ $device == "raspberry-pi2" ] || [ $device == "beaglebone-black" ]; then

			mkdir -p $dockerfilePath/sid
			sed -e s~#{FROM}~resin/$baseImage:$suite~g $template > $dockerfilePath/sid/Dockerfile		
		fi
	done
done

