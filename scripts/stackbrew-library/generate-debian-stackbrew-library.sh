#!/bin/bash
set -e

declare -A aliases
aliases=(
	[jessie]='latest'
)

if [ ! -d 'library' ]; then
	mkdir 'library'
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

		echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>' > "$destDir/$lib_name"
		url='git://github.com/resin-io-library/base-images'
		for version in "${versions[@]}"; do
			versionAliases=( $version ${aliases[$version]} )
			commit="$(git log -1 --format='format:%H' -- "$arch/$version")"
			echo >> $lib_name
			for va in "${versionAliases[@]}"; do
				echo "$va: ${url}@${commit} $root/$arch/$version" >> "$destDir/$lib_name"
			done
		done
	done
fi
