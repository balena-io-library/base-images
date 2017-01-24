#!/bin/bash
set -e
set -o pipefail

# Generate library file.
# $1 : device type
# $2 : distribution
function generate_library(){
	if [ $2 == 'debian' ]; then
		lib_name="$1-buildpack-deps"
	else
		lib_name="$1-$2-buildpack-deps"
	fi
	path="$1/$2"

	cd $path
	versions=( */ )
	versions=( "${versions[@]%/}" )
	cd -

	echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>' > $lib_name
	for version in "${versions[@]}"; do
		versionAliases=( $version ${aliases[$version]} )
		for variant in curl scm; do
			commit="$(git log -1 --format='format:%H' -- "$path/$version/$variant")"
			echo >> $lib_name
			for va in "${versionAliases[@]}"; do
				if [ "$va" = 'latest' ]; then
					va="$variant"
				else
					va="$va-$variant"
				fi
				echo "$va: ${url}@${commit} $repo/$path/$version/$variant" >> $lib_name
			done
		done
			
		commit="$(git log -1 --format='format:%H' -- "$path/$version")"
		echo >> $lib_name
		for va in "${versionAliases[@]}"; do
			echo "$va: ${url}@${commit} $repo/$path/$version" >> $lib_name
		done
	done
}

declare -A aliases
aliases=(
	[jessie]='latest'
	[3.5]='latest'
	[24]='latest'
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE[0]")")"

repo=${PWD##*/}

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
	cd -
	for distro in "${distros[@]}"; do
		generate_library "$device" "$distro"
	done
done

