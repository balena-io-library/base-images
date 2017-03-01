#!/bin/bash
set -e

# for beaglebone
bb_sourceslist_cmd='echo "deb [arch=armhf] http://repos.rcn-ee.net/debian/ #{SUITE} main" >> /etc/apt/sources.list'
bb_key_cmd='apt-key adv --keyserver keyserver.ubuntu.com --recv-key D284E608A4C46402'

# for beaglebone wheezy
bb_sourceslist_wheezy_cmd='echo "deb http://debian.beagleboard.org/packages wheezy-bbb main" >> /etc/apt/sources.list'
bb_key_wheezy_cmd='apt-key adv --keyserver keyserver.ubuntu.com --recv-key B2710B8359890110'

# edison
edison_mraa_version='1.5.1'
edison_mraa_commit='6f9b470d8d25e2c8ba1586cd9d707b870ab30010'

edison_upm_version='1.0.2'
edison_upm_commit='cde747439f7ada792509dd2b56075d4744ac15e4'

# UPM v1.0.1 and above couldn't be built on wheezy so we set v1.0.0 for debian wheezy
edison_wheezy_upm_version='1.0.0'
edison_wheezy_upm_commit='13e2e7aeb8769707b91b62f23d6669d3ee1a8651'


devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 ts7700 raspberrypi3 artik5 artik10 beaglebone-green-wifi qemux86 qemux86-64 beaglebone-green intel-quark artik710 am57xx-evm up-board'
fedora_devices=' raspberrypi2 beaglebone vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 raspberrypi3 artik5 artik10 beaglebone-green-wifi beaglebone-green nuc qemux86-64 artik710 am57xx-evm '
suites='jessie wheezy'
alpine_suites='edge 3.2 3.3 3.4 3.5'
fedora_suites='23 24'

for device in $devices; do

	case "$device" in
	'raspberrypi')
		alpine_template='Dockerfile.alpine.rpi.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'raspberrypi2')
		template='Dockerfile.armv7hf.rpi.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.rpi.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'raspberrypi3')
		template='Dockerfile.armv7hf.rpi.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.rpi.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'beaglebone')
		template='Dockerfile.armv7hf.bbb.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'beaglebone-green-wifi')
		template='Dockerfile.armv7hf.bbb.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'beaglebone-green')
		template='Dockerfile.armv7hf.bbb.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_template='Dockerfile.fedora.tpl'
		fedora_baseImage='armv7hf-fedora'
	;;
	'edison')
		template='Dockerfile.i386.edison.tpl'
		baseImage='i386-debian'
		# TODO: Can't compile mraa on alpine linux atm, lack of necessary libraries.
		#alpine_template='Dockerfile.alpine.i386.edison.tpl'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='i386-alpine'
	;;
	'qemux86')
		template='Dockerfile.tpl'
		baseImage='i386-debian'
		# TODO: Can't compile mraa on alpine linux atm, lack of necessary libraries.
		#alpine_template='Dockerfile.alpine.i386.edison.tpl'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='i386-alpine'
	;;
	'intel-quark')
		template='Dockerfile.tpl'
		baseImage='i386-debian'
		# TODO: Can't compile mraa on alpine linux atm, lack of necessary libraries.
		#alpine_template='Dockerfile.alpine.i386.edison.tpl'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='i386-alpine'
	;;
	'nuc')
		template='Dockerfile.tpl'
		baseImage='amd64-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='amd64-alpine'
		fedora_template='Dockerfile.fedora.tpl'
		fedora_baseImage='amd64-fedora'
	;;
	'qemux86-64')
		template='Dockerfile.tpl'
		baseImage='amd64-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='amd64-alpine'
		fedora_template='Dockerfile.fedora.tpl'
		fedora_baseImage='amd64-fedora'
	;;
	'up-board')
		template='Dockerfile.tpl'
		baseImage='amd64-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='amd64-alpine'
		fedora_template='Dockerfile.fedora.tpl'
		fedora_baseImage='amd64-fedora'
	;;
	'vab820-quad')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'zc702-zynq7')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'odroid-c1')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'odroid-ux3')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'parallella-hdmi-resin')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'nitrogen6x')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'cubox-i')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'ts4900')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'colibri-imx6')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'am57xx-evm')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'nitrogen6x')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'ts7700')
		template='Dockerfile.tpl'
		baseImage='armel-debian'
	;;
	'artik5')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'artik10')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'artik710')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_template='Dockerfile.fedora.tpl'
		fedora_baseImage='armv7hf-fedora'
	;;
	esac

	# Debian.
	debian_dockerfilePath="$device/debian"
	if [ $device != "raspberrypi" ]; then
		for suite in $suites; do
			mkdir -p $debian_dockerfilePath/$suite

			if [[ $device == "beaglebone"* ]]; then
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
				if [[ $device == "edison"* ]]; then
					case "$suite" in
					'wheezy')
						upm_commit=$edison_wheezy_upm_commit
						upm_version=$edison_wheezy_upm_version
					;;
					'jessie')
						upm_commit=$edison_upm_commit
						upm_version=$edison_upm_version
					;;
					esac
					sed -e "s@#{FROM}@resin/$baseImage:$suite@g" \
						-e "s@#{SUITE}@$suite@g" \
						-e "s@#{MRAA_COMMIT}@$edison_mraa_commit@g" \
						-e "s@#{MRAA_VERSION}@$edison_mraa_version@g" \
						-e "s@#{UPM_COMMIT}@$upm_commit@g" \
						-e "s@#{UPM_VERSION}@$upm_version@g" \
						-e "s@#{DEV_TYPE}@$device@g" $template > $debian_dockerfilePath/$suite/Dockerfile
				else
					sed -e s~#{FROM}~resin/$baseImage:$suite~g \
						-e s~#{SUITE}~$suite~g \
						-e s@#{DEV_TYPE}@$device@ $template > $debian_dockerfilePath/$suite/Dockerfile
				fi
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

	# Fedora
	# Only support armv7hf devices. Other devices will be supported later.

	fedora_dockerfilePath="$device/fedora"
	if [[ $fedora_devices == *" $device "* ]]; then
		for suite in $fedora_suites; do
			mkdir -p $fedora_dockerfilePath/$suite
			if [[ $device == "artik"* ]] && [ $suite == "24" ]; then
				# no Artik SDK for fedora 23
				fedora_template='Dockerfile.artik.fedora.tpl'
				cp artik.repo "$fedora_dockerfilePath/$suite/"
				cp RPM-GPG-KEY-artik "$fedora_dockerfilePath/$suite/RPM-GPG-KEY-artik"
				sed -e s~#{FROM}~resin/$fedora_baseImage:$suite~g \
					-e s@#{DEV_TYPE}@$device@ \
					-e s@#{SUITE}@$suite@ $fedora_template > $fedora_dockerfilePath/$suite/Dockerfile
			else
				fedora_template='Dockerfile.fedora.tpl'
				sed -e s~#{FROM}~resin/$fedora_baseImage:$suite~g \
					-e s@#{DEV_TYPE}@$device@ $fedora_template > $fedora_dockerfilePath/$suite/Dockerfile
			fi
		done
	fi
done