#!/bin/bash
set -e

declare -A aliases
aliases=(
	[5.3.0]='0 latest'
)

defaultVersion='0.10.22'

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

repo=${PWD##*/}

devices=( "$@" )
if [ ${#devices[@]} -eq 0 ]; then
	devices=( */ )
fi
devices=( "${devices[@]%/}" )

echo '# maintainer: Joyent Image Team <image-team@joyent.com> (@joyent)'
echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>'

for device in "${devices[@]}"; do

	cd $device
	versions=( */ )
	versions=( "${versions[@]%/}" )
	cd ..
	url='git://github.com/resin-io-library/base-images'
	for version in "${versions[@]}"; do
		commit="$(git log -1 --format='format:%H' -- "$device/$version")"
		fullVersion="$(grep -m1 'ENV NODE_VERSION ' "$device/$version/Dockerfile" | cut -d' ' -f3)"
		if [ $version == 'default' ]; then
			versionAliases=( $fullVersion )
		else
			versionAliases=( $fullVersion $version ${aliases[$fullVersion]} )
		fi

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

		# Only for armv7hf devices
		if [ $device == 'raspberrypi2' ] || [ $device == 'beaglebone' ]; then
			variant='sid'
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
		fi

	done
done
