#!/bin/bash
set -e

repos='armv7hf rpi i386 amd64 armel'
suites='jessie wheezy'

chmod +x entry.sh entry-nosystemd.sh
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
	'amd64')
		baseImage='amd64-debian'
	;;
	'armel')
		baseImage='armel-debian'
	;;
	esac
	for suite in $suites; do
		dockerfilePath=$repo/$suite
		mkdir -p $dockerfilePath
		
		# systemd won't be installed on wheezy images
		if [ $suite == 'wheezy' ]; then
			sed -e s~#{FROM}~resin/$baseImage:$suite~g Dockerfile.nosystemd.tpl > $dockerfilePath/Dockerfile
			cp entry-nosystemd.sh $dockerfilePath/entry.sh
		else
			# jessie and sid images use normal template
			sed -e s~#{FROM}~resin/$baseImage:$suite~g Dockerfile.tpl > $dockerfilePath/Dockerfile
			cp entry.sh launch.service $dockerfilePath/
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
