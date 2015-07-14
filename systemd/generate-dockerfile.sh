#!/bin/bash
set -e

repos='armv7hf rpi i386'
suites='jessie wheezy'

chmod +x entry.sh
for repo in $repos; do
	case "$repo" in
	'rpi')
		baseImage='rpi-raspbian'
	;;
	'armv7hf')
		baseImage='armv7hf-debian'
	;;
	'i386')
		baseImage='i386-debian'
	;;
	esac
	for suite in $suites; do
		dockerfilePath=$repo/$suite
		mkdir -p $dockerfilePath
		
		# wheezy images except rpi will use wheezy template which installs systemd from backports repository
		if [ $suite == 'wheezy' ] && [ $repo != 'rpi' ]; then
			sed -e s~#{FROM}~resin/$baseImage:$suite~g Dockerfile.wheezy.tpl > $dockerfilePath/Dockerfile
			cp entry.sh launch.service $dockerfilePath/
		else
			# systemd won't be installed on rpi-raspbian wheezy	
			if [ $suite == 'wheezy' ] && [ $repo == 'rpi' ]; then
				sed -e s~#{FROM}~resin/$baseImage:$suite~g Dockerfile.nosystemd.tpl > $dockerfilePath/Dockerfile
				cp entry.sh $dockerfilePath/
			else
				# jessie and sid images use normal template
				sed -e s~#{FROM}~resin/$baseImage:$suite~g Dockerfile.tpl > $dockerfilePath/Dockerfile
				cp entry.sh launch.service $dockerfilePath/
			fi
		fi
	done

	# Only for armv7hf
	if [ $repo == 'armv7hf' ]; then
		suite='sid'
		dockerfilePath=$repo/$suite
		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~resin/$baseImage:$suite~g Dockerfile.tpl > $dockerfilePath/Dockerfile
		cp entry.sh launch.service $dockerfilePath/
	fi

done
