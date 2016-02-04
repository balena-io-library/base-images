#!/bin/bash
set -e

declare -A aliases
aliases=(
	[2.7.11]='latest'
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"
echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>'

repo=${PWD##*/}

devices=( */ )
devices=( "${devices[@]%/}" )
url='git://github.com/resin-io-library/base-images'
for device in "${devices[@]}"; do

	cd $device
	versions=( */ )
	versions=( "${versions[@]%/}" )
	cd ..
	for version in "${versions[@]}"; do
		commit="$(git log -1 --format='format:%H' -- "$device/$version")"
		fullVersion="$(grep -m1 'ENV PYTHON_VERSION ' "$device/$version/Dockerfile" | cut -d' ' -f3)"
		versionAliases=( $fullVersion $version ${aliases[$fullVersion]} )

		echo
		for va in "${versionAliases[@]}"; do
			echo "$va: ${url}@${commit} $repo/$device/$version"
		done
	
		for variant in onbuild slim wheezy; do
			commit="$(git log -1 --format='format:%H' -- "$device/$version/$variant")"
			echo
			for va in "${versionAliases[@]}"; do
				if [ "$va" = 'latest' ]; then
					va="$variant"
				else
					va="$va-$variant"
				fi
				echo "$va: ${url}@${commit} $repo/$device/$version/$variant"
			done
		done
	done
done

