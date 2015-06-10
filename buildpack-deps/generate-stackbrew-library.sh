#!/bin/bash
set -e

declare -A aliases
aliases=(
	[jessie]='latest'
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE[0]")")"

devices=( "$@" )
if [ ${#devices[@]} -eq 0 ]; then
	devices=( */ )
fi
devices=( "${devices[@]%/}" )

echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>'
url='git://github.com/nghiant2710/image-tree'

for device in "${devices[@]}"; do
	cd $device
	versions=( "$@" )
	if [ ${#versions[@]} -eq 0 ]; then
		versions=( */ )
	fi
	versions=( "${versions[@]%/}" )
	cd ..
	for version in "${versions[@]}"; do
		versionAliases=( $version ${aliases[$version]} )
		
		for variant in curl scm; do
			commit="$(git log -1 --format='format:%H' -- "$device/$version/$variant")"
			echo
			for va in "${versionAliases[@]}"; do
				if [ "$va" = 'latest' ]; then
					va="$variant"
				else
					va="$va-$variant"
				fi
				echo "$va: ${url}@${commit} $device/$version/$variant"
			done
		done
			
		commit="$(git log -1 --format='format:%H' -- "$device/$version")"
		echo
		for va in "${versionAliases[@]}"; do
			echo "$va: ${url}@${commit} $device/$version"
		done
	done
done

