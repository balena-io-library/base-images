#!/bin/bash
set -e

# for beaglebone
bb_sourceslist_cmd='echo "deb [arch=armhf] http://repos.rcn-ee.net/debian/ #{SUITE} main" >> /etc/apt/sources.list'
bb_key_cmd='apt-key adv --keyserver keyserver.ubuntu.com --recv-key D284E608A4C46402'

# for beaglebone wheezy
bb_sourceslist_wheezy_cmd='echo "deb http://debian.beagleboard.org/packages wheezy-bbb main" >> /etc/apt/sources.list'
bb_key_wheezy_cmd='apt-key adv --keyserver keyserver.ubuntu.com --recv-key B2710B8359890110'

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 ts7700 raspberrypi3'
suites='jessie wheezy'
alpine_suites='edge 3.2 3.3'

for device in $devices; do

	case "$device" in
	'raspberrypi')
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'raspberrypi2')
		template='Dockerfile.armv7hf.rpi.tpl'
		baseImage='armv7hf-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'raspberrypi3')
		template='Dockerfile.armv7hf.rpi.tpl'
		baseImage='armv7hf-systemd'
	;;
	'beaglebone')
		template='Dockerfile.armv7hf.bbb.tpl'
		baseImage='armv7hf-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'edison')
		template='Dockerfile.i386.edison.tpl'
		baseImage='i386-systemd'
		# TODO: Can't compile mraa on alpine linux atm, lack of necessary libraries.
		#alpine_template='Dockerfile.alpine.i386.edison.tpl'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='i386-alpine'
	;;
	'nuc')
		template='Dockerfile.tpl'
		baseImage='amd64-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='amd64-alpine'
	;;
	'vab820-quad')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'zc702-zynq7')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'odroid-c1')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'odroid-ux3')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'parallella-hdmi-resin')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'nitrogen6x')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'cubox-i')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'ts4900')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'colibri-imx6')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'apalis-imx6')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'ts7700')
		template='Dockerfile.tpl'
		baseImage='armel-systemd'
	;;
	esac

	# Debian.
	debian_dockerfilePath="$device/debian"
	if [ $device != "raspberrypi" ]; then
		for suite in $suites; do
			mkdir -p $debian_dockerfilePath/$suite

			if [ $device == 'beaglebone' ]; then
				case "$suite" in
				'wheezy')
					sourcelist="$bb_sourceslist_cmd \&\& $bb_sourceslist_wheezy_cmd"
					key="$bb_key_cmd \&\& $bb_key_wheezy_cmd"
				;;
				'jessie')
					sourcelist="$bb_sourceslist_cmd"
					key="$bb_key_cmd"
				;;
				esac

			sed -e "s@#{FROM}@resin/$baseImage:$suite@g" \
				-e "s@#{SOURCES_LIST}@$sourcelist@g" \
				-e "s@#{SUITE}@$suite@g" \
				-e "s@#{KEYS}@$key@g" \
				-e "s@#{DEV_TYPE}@$device@g" $template > $debian_dockerfilePath/$suite/Dockerfile
			else
				sed -e s~#{FROM}~resin/$baseImage:$suite~g \
					-e s~#{SUITE}~$suite~g \
					-e s@#{DEV_TYPE}@$device@ $template > $debian_dockerfilePath/$suite/Dockerfile
			fi
		done
	fi

	# Alpine.

	# armel device not supported yet.
	if [ $device == "ts7700" ]; then
		continue
	fi

	alpine_dockerfilePath="$device/alpine"
	for suite in $alpine_suites; do
		mkdir -p $alpine_dockerfilePath/$suite
		sed -e s~#{FROM}~resin/$alpine_baseImage:$suite~g \
			-e s@#{DEV_TYPE}@$device@ $alpine_template > $alpine_dockerfilePath/$suite/Dockerfile
	done
done
