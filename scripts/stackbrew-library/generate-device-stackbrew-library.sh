#!/bin/bash
set -e
set -o pipefail

# Generate library file.
# $1 : device type
# $2 : distribution
function generate_library(){
	lib_name="$1-$2"
	path="$1/$2"

	cd $path
	suites=( */ )
	suites=( "${suites[@]%/}" )
	cd -

	echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>' > "$destDir/$lib_name"
	for suite in "${suites[@]}"; do
		suiteAliases=( $suite ${aliases[$suite]} )
		commit="$(git log -1 --format='format:%H' -- "$path/$suite")"
		echo >> "$destDir/$lib_name"
		for va in "${suiteAliases[@]}"; do
			echo "$va: ${url}@${commit} $repo/$path/$suite" >> "$destDir/$lib_name"
		done
	done
}

declare -A aliases
aliases=(
	[jessie]='latest'
	[3.7]='latest'
	[26]='latest'
	[bionic]='latest'
)

destDir="${PWD}/library"
root='resin-base-images/device-base'

if [ -d "$root" ]; then
	cd $root

	devices=( "$@" )
	if [ ${#devices[@]} -eq 0 ]; then
		devices=( */ )
	fi
	devices=( "${devices[@]%/}" )
	url='git://github.com/resin-io-library/base-images'

	for device in "${devices[@]}"; do
		cd $device
		distros=( */ )
		distros=( "${distros[@]%/}" )
		cd ..
		for distro in "${distros[@]}"; do
			generate_library "$device" "$distro"
		done
	done
fi

