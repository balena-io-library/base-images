#!/bin/bash
set -e

declare -A aliases
aliases=(
	[26]='latest'
)

if [ ! -d 'library' ]; then
	mkdir 'library'
fi

destDir="${PWD}/library"
root='resin-base-images/fedora'

if [ -d "$root" ]; then
	cd $root
	
	repos=( "$@" )
	if [ ${#repos[@]} -eq 0 ]; then
		repos=( */ )
	fi
	repos=( "${repos[@]%/}" )

	for repo in "${repos[@]}"; do

		# Library file name
		lib_name="$repo-fedora"

		cd $repo
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
			commit="$(git log -1 --format='format:%H' -- "$repo/$version")"
			echo >> $lib_name
			for va in "${versionAliases[@]}"; do
				echo "$va: ${url}@${commit} $root/$repo/$version" >> "$destDir/$lib_name"
			done
		done
	done
fi
