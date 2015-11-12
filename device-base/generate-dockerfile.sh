#!/bin/bash
set -e

# for beaglebone
bb_sourceslist_cmd='echo "deb [arch=armhf] http://repos.rcn-ee.net/debian/ #{SUITE} main" >> /etc/apt/sources.list'
bb_key_cmd='apt-key adv --keyserver keyserver.ubuntu.com --recv-key D284E608A4C46402'

# for beaglebone wheezy
bb_sourceslist_wheezy_cmd='echo "deb http://debian.beagleboard.org/packages wheezy-bbb main" >> /etc/apt/sources.list'
bb_key_wheezy_cmd='apt-key adv --keyserver keyserver.ubuntu.com --recv-key B2710B8359890110'

devices='raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6'
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
	'nuc')
		template='Dockerfile.tpl'
		baseImage='amd64-systemd'
	;;
	'vab820-quad')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
	;;
	'zc702-zynq7')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
	;;
	'odroid-c1')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
	;;
	'odroid-ux3')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
	;;
	'parallella-hdmi-resin')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
	;;
	'nitrogen6x')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
	;;
	'cubox-i')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
	;;
	'ts4900')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
	;;
	'colibri-imx6')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
	;;
	'apalis-imx6')
		template='Dockerfile.tpl'
		baseImage='armv7hf-systemd'
	;;
	esac

	for suite in $suites; do
		dockerfilePath="$device"
		mkdir -p $dockerfilePath/$suite

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
			-e "s@#{KEYS}@$key@g" $template > $dockerfilePath/$suite/Dockerfile
		else
			sed -e s~#{FROM}~resin/$baseImage:$suite~g \
				-e s~#{SUITE}~$suite~g $template > $dockerfilePath/$suite/Dockerfile
		fi
	done
done

