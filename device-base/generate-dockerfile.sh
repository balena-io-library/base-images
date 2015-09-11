#!/bin/bash
set -e

# for beaglebone wheezy 
bb_sourceslist_wheezy_cmd='echo "deb [arch=armhf] http://repos.rcn-ee.net/debian/ #{SUITE} main" >> /etc/apt/sources.list \&\& echo "deb http://debian.beagleboard.org/packages  #{SUITE}-bbb main" >> /etc/apt/sources.list'

# for beaglebone jessie
bb_sourceslist_jessie_cmd='echo "deb [arch=armhf] http://repos.rcn-ee.net/debian/ #{SUITE} main" >> /etc/apt/sources.list'

# beaglebone rcn-ee repo
bb_rcn_ee_wheezy_key='rcn-ee-archive-keyring_2015.07.05~bpo70+20150705+1_all.deb'
bb_rcn_ee_jessie_key='rcn-ee-archive-keyring_2015.07.05~bpo80+20150705+1_all.deb'

bb_board_wheezy_key_cmd='apt-key adv --keyserver keyserver.ubuntu.com --recv-key B2710B8359890110'

bb_rcn_ee_key_cmd='wget http://repos.rcn-ee.net/debian/pool/main/r/rcn-ee-archive-keyring/#{KEY_NAME} \&\& dpkg -i #{KEY_NAME} \&\& rm -f #{KEY_NAME}'

devices='raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i'
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
	esac

	for suite in $suites; do
		dockerfilePath="$device"
		mkdir -p $dockerfilePath/$suite

		if [ $device == 'beaglebone' ]; then
			case "$suite" in
			'wheezy')
				sourcelist="$bb_sourceslist_wheezy_cmd"
				key="$bb_board_wheezy_key_cmd \&\& $bb_rcn_ee_key_cmd"
				key=$(echo $key | sed "s@#{KEY_NAME}@$bb_rcn_ee_wheezy_key@g")
			;;
			'jessie')
				sourcelist="$bb_sourceslist_jessie_cmd"
				key="$bb_rcn_ee_key_cmd"
				key=$(echo $key | sed "s@#{KEY_NAME}@$bb_rcn_ee_jessie_key@g")
			;;
			esac

		sed -e "s@#{FROM}@resin/$baseImage:$suite@g" \
			-e "s@#{SOURCES_LIST}@$sourcelist@g" \
			-e "s@#{SUITE}@$suite@g" \
			-e "s@#{KEYS}@$key@g" $template > $dockerfilePath/$suite/Dockerfile
		else
			sed -e s~#{FROM}~resin/$baseImage:$suite~g \
				-e s~#{SUITE}~$suite~g $template > $dockerfilePath/$suite/Dockerfile
			# Copy new scripts to edison images
			if [ $device == 'edison' ]; then
				case "$suite" in
				'wheezy')
					# For wheezy images, replace entry.sh script
					cp entry-edison-nosystemd.sh $dockerfilePath/$suite/entry.sh
					echo "COPY entry.sh /usr/bin/" >> $dockerfilePath/$suite/Dockerfile
				;;
				'jessie')
					# For jessie images, add systemd mount service
					cp sys-kernel-debug.mount $dockerfilePath/$suite/
					echo "COPY sys-kernel-debug.mount /etc/systemd/system/" >> $dockerfilePath/$suite/Dockerfile
					echo "RUN systemctl enable /etc/systemd/system/sys-kernel-debug.mount" >> $dockerfilePath/$suite/Dockerfile
				;;
				esac
			fi
		fi
	done
done

