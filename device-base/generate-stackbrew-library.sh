#!/bin/bash
set -e

declare -A aliases
aliases=(
	[jessie]='latest'
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"
echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>'

repo=${PWD##*/}

devices=( "$@" )
if [ ${#devices[@]} -eq 0 ]; then
	devices=( */ )
fi
devices=( "${devices[@]%/}" )
url='git://github.com/resin-io-library/base-images'

for device in "${devices[@]}"; do
	cd $device
	suites=( */ )
	suites=( "${suites[@]%/}" )
	cd ..
	for suite in "${suites[@]}"; do
		suiteAliases=( $suite ${aliases[$suite]} )

		commit="$(git log -1 --format='format:%H' -- "$device/$suite")"
		echo
		for va in "${suiteAliases[@]}"; do
			echo "$va: ${url}@${commit} $repo/$device/$suite"
		done
	done
done

