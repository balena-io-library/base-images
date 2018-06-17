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
	[3.7]='latest'
)
imageVersion='1'

if [ ! -d 'library' ]; then
	mkdir -p 'library/resin'
	mkdir -p 'library/balena'
fi

destDir="${PWD}/library"
root='resin-base-images/alpine'

if [ -d "$root" ]; then
	cd $root

	repos=( "$@" )
	if [ ${#repos[@]} -eq 0 ]; then
		repos=( */ )
	fi
	repos=( "${repos[@]%/}" )

	for repo in "${repos[@]}"; do

		# Library file name
		lib_name="$repo-alpine"

		cd $repo
		versions=( "$@" )
		if [ ${#versions[@]} -eq 0 ]; then
			versions=( */ )
		fi
		versions=( "${versions[@]%/}" )
		cd ..

		url='git://github.com/resin-io-library/base-images'
		for version in "${versions[@]}"; do
			versionAliases=( $version ${aliases[$version]} )
			commit="$(git log -1 --format='format:%H' -- "$repo/$version")"
			for va in "${versionAliases[@]}"; do
				print_tag "$va" "${url}@${commit} $root/$repo/$version"
			done
		done
	done
fi
