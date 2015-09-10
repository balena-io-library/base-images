#!/bin/bash
set -e

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3'
suites='jessie wheezy'

for device in $devices; do
	if [ $device == 'edison' ]; then
		template='Dockerfile.i386.edison.tpl'
	else
		template='Dockerfile.tpl'
	fi
	for suite in $suites; do
		dockerfilePath="$device"
		mkdir -p $dockerfilePath/$suite
		sed -e s~#{FROM}~resin/$device-buildpack-deps:$suite~g $template > $dockerfilePath/$suite/Dockerfile
	done
done

