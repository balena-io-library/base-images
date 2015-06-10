#!/bin/bash
set -e

declare -A aliases
aliases=(
	[jessie]='latest'
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"
echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>'

devices=( "$@" )
if [ ${#devices[@]} -eq 0 ]; then
	devices=( */ )
fi
devices=( "${devices[@]%/}" )
cd ..
url='git://github.com/nghiant2710/image-tree'
for device in "${devices[@]}"; do

	cd $device
	suites=( */ )
	suites=( "${suites[@]%/}" )
	cd ..
	for suite in "${suites[@]}"; do
		suiteAliases=( $suite ${aliases[$suite]} )

		commit="$(git log -1 --format='format:%H' -- "$device/$suite")"
		echo
		for va in "${deviceAliases[@]}"; do
			echo "$va: ${url}@${commit} $device/$suite"
		done
			
		# Only for armv7hf devices
		if [ $device == 'raspberry-pi2' ] || [ $device == 'beaglebone-black' ]; then
			suite='sid'
			commit="$(git log -1 --format='format:%H' -- "$device/$suite")"
			echo
			echo "$va: ${url}@${commit} $device/$suite"
		fi
	done
done

