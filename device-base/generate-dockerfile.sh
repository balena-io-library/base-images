#!/bin/bash
set -e

# for rpi family
rpi_sourcelist='echo "deb http://archive.raspbian.org/raspbian #{SUITE} main contrib non-free rpi firmware" >>  /etc/apt/sources.list \\\
	\&\& apt-key adv --keyserver pgp.mit.edu  --recv-key 0x9165938D90FDDD2E \\\
	\&\& echo "deb http://archive.raspberrypi.org/debian #{SUITE} main" >>  /etc/apt/sources.list.d/raspi.list \\\
	\&\& apt-key adv --keyserver pgp.mit.edu  --recv-key 0x82B129927FA3303E'

rpi_sourcelist_buster='echo "deb http://archive.raspbian.org/raspbian #{SUITE} main contrib non-free rpi firmware" >>  /etc/apt/sources.list \\\
	\&\& apt-key adv --keyserver pgp.mit.edu  --recv-key 0x9165938D90FDDD2E'

# for beaglebone
bb_sourceslist_cmd='echo "deb [arch=armhf] http://repos.rcn-ee.net/debian/ #{SUITE} main" >> /etc/apt/sources.list'
bb_key_cmd='apt-key adv --keyserver keyserver.ubuntu.com --recv-key D284E608A4C46402'

# for beaglebone wheezy
bb_sourceslist_wheezy_cmd='echo "deb http://debian.beagleboard.org/packages wheezy-bbb main" >> /etc/apt/sources.list'
bb_key_wheezy_cmd='apt-key adv --keyserver keyserver.ubuntu.com --recv-key B2710B8359890110'

# intel-edison
intel_edison_mraa_version='1.8.0'
intel_edison_mraa_commit='eb7238d9afea044701dba1c26cc5076854e3238c'

intel_edison_upm_version='1.5.0'
intel_edison_upm_commit='b9010059ade9b3ee9fb343b23c506acaed7d0b15'

devices='raspberry-pi raspberry-pi2 beaglebone-black intel-edison intel-nuc via-vab820-quad zc702-zynq7 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q ts7700 raspberrypi3 artik5 artik10 beaglebone-green-wifi qemux86 qemux86-64 beaglebone-green cybertan-ze250 artik710 am571x-evm up-board kitra710 imx6ul-var-dart kitra520 jetson-tx2 iot2000'
fedora_devices=' raspberry-pi2 beaglebone-black via-vab820-quad zc702-zynq7 odroid-c1 odroid-xu4 parallella nitrogen6x hummingboard ts4900 colibri-imx6dl apalis-imx6q raspberrypi3 artik5 artik10 beaglebone-green-wifi beaglebone-green intel-nuc qemux86-64 artik710 am571x-evm kitra710 up-board imx6ul-var-dart kitra520 jetson-tx2 '
suites='jessie wheezy stretch buster'
alpine_suites='3.5 3.6'
fedora_suites='24 25 26'

for device in $devices; do

	case "$device" in
	'raspberry-pi')
		alpine_template='Dockerfile.alpine.rpi.tpl'
		alpine_baseImage='armhf-alpine'
	;;
	'raspberry-pi2')
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
	'beaglebone-black')
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
	'intel-edison')
		template='Dockerfile.i386.edison.tpl'
		baseImage='i386-debian'
		# TODO: Can't compile mraa on alpine linux atm, lack of necessary libraries.
		#alpine_template='Dockerfile.alpine.i386.intel-edison.tpl'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='i386-alpine'
	;;
	'qemux86')
		template='Dockerfile.tpl'
		baseImage='i386-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='i386-alpine'
	;;
	'cybertan-ze250')
		template='Dockerfile.tpl'
		baseImage='i386-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='i386-alpine'
	;;
	'iot2000')
		template='Dockerfile.tpl'
		baseImage='i386-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='i386-alpine'
	;;
	'intel-nuc')
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
	'via-vab820-quad')
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
	'odroid-xu4')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'parallella')
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
	'hummingboard')
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
	'colibri-imx6dl')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_baseImage='armv7hf-fedora'
	;;
	'am571x-evm')
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
	'kitra710')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_template='Dockerfile.fedora.tpl'
		fedora_baseImage='armv7hf-fedora'
	;;
	'kitra520')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_template='Dockerfile.fedora.tpl'
		fedora_baseImage='armv7hf-fedora'
	;;
	'imx6ul-var-dart')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_template='Dockerfile.fedora.tpl'
		fedora_baseImage='armv7hf-fedora'
	;;
	'ccon-01')
		template='Dockerfile.tpl'
		baseImage='armv7hf-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='armhf-alpine'
		fedora_template='Dockerfile.fedora.tpl'
		fedora_baseImage='armv7hf-fedora'
	;;
	'jetson-tx2')
		template='Dockerfile.tpl'
		baseImage='aarch64-debian'
		alpine_template='Dockerfile.alpine.tpl'
		alpine_baseImage='aarch64-alpine'
		fedora_baseImage='aarch64-fedora'
	;;
	esac

	# Debian.
	debian_dockerfilePath="$device/debian"
	if [ $device != "raspberry-pi" ]; then
		for suite in $suites; do
			mkdir -p $debian_dockerfilePath/$suite

			case "$device" in
			"beaglebone"*)
				case "$suite" in
				'wheezy')
					sourcelist="$bb_sourceslist_cmd \&\& $bb_sourceslist_wheezy_cmd"
					key="$bb_key_cmd \&\& $bb_key_wheezy_cmd"
				;;
				*)
					# jessie and stretch
					sourcelist="$bb_sourceslist_cmd"
					key="$bb_key_cmd"
				;;
				esac

				sed -e "s@#{FROM}@resin/$baseImage:$suite@g" \
					-e "s@#{SOURCES_LIST}@$sourcelist@g" \
					-e "s@#{SUITE}@$suite@g" \
					-e "s@#{KEYS}@$key@g" \
					-e "s@#{DEV_TYPE}@$device@g" $template > $debian_dockerfilePath/$suite/Dockerfile
			;;
			"intel-edison"*)
				sed -e "s@#{FROM}@resin/$baseImage:$suite@g" \
					-e "s@#{SUITE}@$suite@g" \
					-e "s@#{MRAA_COMMIT}@$intel_edison_mraa_commit@g" \
					-e "s@#{MRAA_VERSION}@$intel_edison_mraa_version@g" \
					-e "s@#{UPM_COMMIT}@$intel_edison_upm_commit@g" \
					-e "s@#{UPM_VERSION}@$intel_edison_upm_commit@g" \
					-e "s@#{DEV_TYPE}@$device@g" $template > $debian_dockerfilePath/$suite/Dockerfile
			;;
			"raspberry"*)
				case "$suite" in
				'buster')
					# raspberrypi foundation doesn't have buster yet.
					sourcelist=$rpi_sourcelist_buster
				;;
				*)
					# jessie and wheezy
					sourcelist=$rpi_sourcelist
				;;
				esac
				sed -e "s@#{FROM}@resin/$baseImage:$suite@g" \
					-e "s@#{SOURCES_LIST}@$sourcelist@g" \
					-e "s@#{SUITE}@$suite@g" \
					-e "s@#{DEV_TYPE}@$device@g" $template > $debian_dockerfilePath/$suite/Dockerfile
			;;
			*)
				sed -e s~#{FROM}~resin/$baseImage:$suite~g \
					-e s~#{SUITE}~$suite~g \
					-e s@#{DEV_TYPE}@$device@ $template > $debian_dockerfilePath/$suite/Dockerfile

				if [ $device == "iot2000" ]; then
					cat Dockerfile.i386.iot2000.partial >> $debian_dockerfilePath/$suite/Dockerfile
				fi
			;;
			esac
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
			if ( [[ $device == "artik"* ]] || [[ $device == "kitra"* ]] ) && [ $suite == "24" ]; then
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
