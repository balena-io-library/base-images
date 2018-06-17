#!/bin/bash
set -e

function print_tag(){
	# Print with resin and balena formats.
	# $1: tag
	# $2: content

	# resin
	echo "$1: $2" >> "$destDir/resin/$lib_name"

	# balena
	# new format: <baseImageSeries>-<stack1version>-<stack2version>-...-<stackNversion>
	echo "$imageVersion-$1: $2" >> "$destDir/balena/$lib_name"
}

declare -A aliases
aliases=(
	[jessie]='latest'
)
imageVersion='1'

if [ ! -d 'library' ]; then
	mkdir -p 'library/resin'
	mkdir -p 'library/balena'
fi

destDir="${PWD}/library"
root='resin-base-images/debian'

if [ -d "$root" ]; then
	cd $root

	archs=( "$@" )
	if [ ${#archs[@]} -eq 0 ]; then
		archs=( */ )
	fi
	archs=( "${archs[@]%/}" )

	for arch in "${archs[@]}"; do

		# Library file name
		lib_name="$arch-debian"

		cd $arch
		versions=( "$@" )
		if [ ${#versions[@]} -eq 0 ]; then
			versions=( */ )
		fi
		versions=( "${versions[@]%/}" )
		cd ..

		url='git://github.com/resin-io-library/base-images'
		for version in "${versions[@]}"; do
			versionAliases=( $version ${aliases[$version]} )
			commit="$(git log -1 --format='format:%H' -- "$arch/$version")"
			for va in "${versionAliases[@]}"; do
				print_tag "$va" "${url}@${commit} $root/$repo/$version"
			done
		done
	done
fi
