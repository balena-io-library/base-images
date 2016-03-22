#!/bin/bash
set -e

declare -A aliases
aliases=(
	[jessie]='latest'
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE[0]")")"

root=${PWD##*/}

repos=( "$@" )
if [ ${#repos[@]} -eq 0 ]; then
	repos=( */ )
fi
repos=( "${repos[@]%/}" )

for repo in "${repos[@]}"; do

	# Library file name
	if [ $repo == 'rpi' ]; then
		lib_name="raspberrypi-systemd"
	else
		lib_name="$repo-systemd"
	fi

	cd $repo
	versions=( "$@" )
	if [ ${#versions[@]} -eq 0 ]; then
		versions=( */ )
	fi
	versions=( "${versions[@]%/}" )
	cd ..

	echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>' > $lib_name
	url='git://github.com/resin-io-library/base-images'
	for version in "${versions[@]}"; do
		versionAliases=( $version ${aliases[$version]} )
		commit="$(git log -1 --format='format:%H' -- "$repo/$version")"
		echo >> $lib_name
		for va in "${versionAliases[@]}"; do
			echo "$va: ${url}@${commit} $root/$repo/$version" >> $lib_name
		done
	done
done
