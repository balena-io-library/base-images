#!/bin/bash
set -e

PYTHON2_PATH="/usr/lib/python2.7/dist-packages"
PYTHON3_PATH="/usr/lib/python3/dist-packages"
PYTHON2_ARGS="-DBUILDSWIGNODE=OFF"
PYTHON3_ARGS="-DBUILDSWIGNODE=OFF -DBUILDPYTHON3=ON -DPYTHON_INCLUDE_DIR=/usr/local/include/python3.5m/ -DPYTHON_LIBRARY=/usr/local/lib/libpython3.so"

# append mraa build script to the bottom of Dockerfile.
# $1: base version
# $2: path
# $3: distro
# $4: variants
append_setup_script() {
	# Can build mraa on alpine linux, lack of necessary libraries.
	if [ $3 == 'debian' ]; then
		script_file='setup.sh'
	fi
	for va in $4; do

		if [ $va == 'base' ]; then
			tmp_path=$2
		else
			tmp_path="$2/$va"
		fi
		cp $script_file $tmp_path
		echo "COPY $script_file /$script_file" >> $tmp_path/Dockerfile
		echo "RUN bash /$script_file && rm /$script_file" >> $tmp_path/Dockerfile
		if [ $1 != "2.7" ]; then
			sed -i -e s~#{ARGS}~"$PYTHON3_ARGS"~g $tmp_path/$script_file
		else
			sed -i -e s~#{ARGS}~"$PYTHON2_ARGS"~g $tmp_path/$script_file
		fi
	done
}

# set PYTHONPATH to point to dist-packages
# $1: base version
# $2: path
# $3: variants
set_pythonpath() {
	for va in $3; do

		if [ $va == 'base' ]; then
			tmp_path=$2
		else
			tmp_path="$2/$va"
		fi

		if [ $1 != "2.7" ]; then
			echo "ENV PYTHONPATH $PYTHON3_PATH" >> $tmp_path/Dockerfile
		else
			echo "ENV PYTHONPATH $PYTHON2_PATH" >> $tmp_path/Dockerfile
		fi
	done
}

devices='raspberrypi raspberrypi2 beaglebone edison nuc vab820-quad zc702-zynq7 odroid-c1 odroid-ux3 parallella-hdmi-resin nitrogen6x cubox-i ts4900 colibri-imx6 apalis-imx6 ts7700 raspberrypi3'
pythonVersions='2.7.11 3.3.6 3.4.4 3.5.1'

for device in $devices; do
	for pythonVersion in $pythonVersions; do

		if [ $pythonVersion != "2.7.11" ]; then
			template='Dockerfile.python3.tpl'
			slimTemplate='Dockerfile.python3.slim.tpl'
		else
			template='Dockerfile.tpl'
			slimTemplate='Dockerfile.slim.tpl'
		fi

		case "$pythonVersion" in
		'2.7.11')
			gpgKey='gpg --keyserver ha.pool.sks-keyservers.net --recv-keys C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF'
		;;
		'3.3.6')
			gpgKey='gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 26DEA9D4613391EF3E25C9FF0A5B101836580288'
		;;
		'3.4.4')
			gpgKey='gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 97FC712E4C024BBEA48A61ED3A5CA953F73C700D'
		;;
		'3.5.1')
			gpgKey='gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 97FC712E4C024BBEA48A61ED3A5CA953F73C700D'
		;;
		esac

		baseVersion=$(expr match "$pythonVersion" '\([0-9]*\.[0-9]*\)')

		# Debian
		debian_dockerfilePath=$device/debian/$baseVersion
		mkdir -p $debian_dockerfilePath
		sed -e s~#{FROM}~"resin/$device-buildpack-deps:jessie"~g \
			-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
			-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
			-e s~#{GPG_KEY}~"$gpgKey"~g $template > $debian_dockerfilePath/Dockerfile

		mkdir -p $debian_dockerfilePath/wheezy
		sed -e s~#{FROM}~"resin/$device-buildpack-deps:wheezy"~g \
			-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
			-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
			-e s~#{GPG_KEY}~"$gpgKey"~g $template > $debian_dockerfilePath/wheezy/Dockerfile

		mkdir -p $debian_dockerfilePath/onbuild
		sed -e s~#{FROM}~"resin/$device-python:$pythonVersion"~g Dockerfile.onbuild.tpl > $debian_dockerfilePath/onbuild/Dockerfile
		mkdir -p $debian_dockerfilePath/slim

		# Only for RPI1 device
		if [ $device == "raspberrypi" ]; then
			sed -e s~#{FROM}~"resin/$device-systemd:jessie"~g \
				-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
				-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
				-e s~#{GPG_KEY}~"$gpgKey"~g $slimTemplate > $debian_dockerfilePath/slim/Dockerfile
		else
			sed -e s~#{FROM}~"resin/$device-debian:jessie"~g \
				-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
				-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
				-e s~#{GPG_KEY}~"$gpgKey"~g $slimTemplate > $debian_dockerfilePath/slim/Dockerfile
		fi

		# Only for intel edison
		if [ $device == "edison" ]; then
			append_setup_script "$baseVersion" "$debian_dockerfilePath" "debian" "base wheezy slim"

		fi

		set_pythonpath "$baseVersion" "$debian_dockerfilePath" "base wheezy slim"

		# Alpine
		# TODO: install mraa on Edison

		# armel device not supported yet.
		if [ $device == "ts7700" ]; then
			continue
		fi

		if [ $pythonVersion != "2.7.11" ]; then
			template='Dockerfile.alpine.python3.tpl'
			slimTemplate='Dockerfile.alpine.python3.slim.tpl'
		else
			template='Dockerfile.alpine.tpl'
			slimTemplate='Dockerfile.alpine.slim.tpl'
		fi

		alpine_dockerfilePath=$device/alpine/$baseVersion
		mkdir -p $alpine_dockerfilePath
		sed -e s~#{FROM}~"resin/$device-alpine-buildpack-deps:latest"~g \
			-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
			-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
			-e s~#{GPG_KEY}~"$gpgKey"~g $template > $alpine_dockerfilePath/Dockerfile

		mkdir -p $alpine_dockerfilePath/onbuild
		sed -e s~#{FROM}~"resin/$device-alpine-python:$pythonVersion"~g Dockerfile.onbuild.tpl > $alpine_dockerfilePath/onbuild/Dockerfile

		mkdir -p $alpine_dockerfilePath/slim
		sed -e s~#{FROM}~"resin/$device-alpine:latest"~g \
			-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
			-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
			-e s~#{GPG_KEY}~"$gpgKey"~g $slimTemplate > $alpine_dockerfilePath/slim/Dockerfile

		mkdir -p $alpine_dockerfilePath/edge
		sed -e s~#{FROM}~"resin/$device-alpine-buildpack-deps:edge"~g \
			-e s~#{PYTHON_VERSION}~"$pythonVersion"~g \
			-e s~#{PYTHON_BASE_VERSION}~"$baseVersion"~g \
			-e s~#{GPG_KEY}~"$gpgKey"~g $template > $alpine_dockerfilePath/edge/Dockerfile

		set_pythonpath "$baseVersion" "$alpine_dockerfilePath" "base edge slim"
	done
done
