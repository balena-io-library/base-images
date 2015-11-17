#!/bin/bash
set -e

PYTHON2_PATH="/usr/lib/python2.7/dist-packages"
PYTHON3_PATH="/usr/lib/python3/dist-packages"

# append mraa build script to the bottom of Dockerfile.
append_setup_script() {
	if [ $1 != "2.7" ]; then
		cp setup.sh $2
		echo "COPY setup.sh /setup.sh" >> $2/Dockerfile
		echo "RUN bash /setup.sh && rm /setup.sh" >> $2/Dockerfile
	fi
}

# set PYTHONPATH to point to dist-packages
set_pythonpath() {
	if [ $1 != "2.7" ]; then
		echo "ENV PYTHONPATH $PYTHON3_PATH" >> $2/Dockerfile
		echo "ENV PYTHONPATH $PYTHON3_PATH" >> $2/wheezy/Dockerfile
		echo "ENV PYTHONPATH $PYTHON3_PATH" >> $2/slim/Dockerfile
	else
		echo "ENV PYTHONPATH $PYTHON2_PATH" >> $2/Dockerfile
		echo "ENV PYTHONPATH $PYTHON2_PATH" >> $2/wheezy/Dockerfile
		echo "ENV PYTHONPATH $PYTHON2_PATH" >> $2/slim/Dockerfile
	fi
}


devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6'
pythonVersions='2.7.10 3.2.6 3.3.6 3.4.3 3.5.0'

for device in $devices; do
	for pythonVersion in $pythonVersions; do

		if [ $pythonVersion != "2.7.10" ]; then
			template='Dockerfile.python3.tpl'
			slimTemplate='Dockerfile.python3.slim.tpl'
		else
			template='Dockerfile.tpl'
			slimTemplate='Dockerfile.slim.tpl'
		fi

		case "$pythonVersion" in
		'2.7.10')
			gpgKey='gpg --keyserver ha.pool.sks-keyservers.net --recv-keys C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF'
		;;
		'3.2.6')
			gpgKey='gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 26DEA9D4613391EF3E25C9FF0A5B101836580288'
		;;
		'3.3.6')
			gpgKey='gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 26DEA9D4613391EF3E25C9FF0A5B101836580288'
		;;
		'3.4.3')
			gpgKey='gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 97FC712E4C024BBEA48A61ED3A5CA953F73C700D'
		;;
		'3.5.0')
			gpgKey='gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 97FC712E4C024BBEA48A61ED3A5CA953F73C700D'
		;;
		esac

		baseVersion=$(expr match "$pythonVersion" '\([0-9]*\.[0-9]*\)')

		dockerfilePath=$device/$baseVersion
		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~"resin/$device-buildpack-deps:jessie"~g \
			-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
			-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
			-e s~#{GPG_KEY}~"$gpgKey"~g $template > $dockerfilePath/Dockerfile

		mkdir -p $dockerfilePath/wheezy
		sed -e s~#{FROM}~"resin/$device-buildpack-deps:wheezy"~g \
			-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
			-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
			-e s~#{GPG_KEY}~"$gpgKey"~g $template > $dockerfilePath/wheezy/Dockerfile

		mkdir -p $dockerfilePath/onbuild
		sed -e s~#{FROM}~"resin/$device-python:$pythonVersion"~g Dockerfile.onbuild.tpl > $dockerfilePath/onbuild/Dockerfile
		mkdir -p $dockerfilePath/slim

		# Only for RPI1 device
		if [ $device == "raspberrypi" ]; then
			sed -e s~#{FROM}~"resin/$device-systemd:jessie"~g \
				-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
				-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
				-e s~#{GPG_KEY}~"$gpgKey"~g $slimTemplate > $dockerfilePath/slim/Dockerfile
		else
			sed -e s~#{FROM}~"resin/$device-debian:jessie"~g \
				-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
				-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
				-e s~#{GPG_KEY}~"$gpgKey"~g $slimTemplate > $dockerfilePath/slim/Dockerfile
		fi

		# Only for intel edison
		if [ $device == "edison" ]; then
			sed -e s~#{FROM}~"resin/$device-buildpack-deps:jessie"~g \
				-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
				-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
				-e s~#{GPG_KEY}~"$gpgKey"~g $template > $dockerfilePath/Dockerfile

			sed -e s~#{FROM}~"resin/$device-buildpack-deps:wheezy"~g \
				-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
				-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
				-e s~#{GPG_KEY}~"$gpgKey"~g $template > $dockerfilePath/wheezy/Dockerfile

			sed -e s~#{FROM}~"resin/$device-debian:jessie"~g \
				-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
				-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
				-e s~#{GPG_KEY}~"$gpgKey"~g $slimTemplate > $dockerfilePath/slim/Dockerfile

			# Only append setup script to Python3 images
			append_setup_script $baseVersion $dockerfilePath/
			append_setup_script $baseVersion $dockerfilePath/wheezy/
			append_setup_script $baseVersion $dockerfilePath/slim/
		fi

		set_pythonpath $baseVersion $dockerfilePath/	
	done
done
