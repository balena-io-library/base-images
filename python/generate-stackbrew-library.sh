#!/bin/bash
set -e
set -o pipefail

# Generate library file.
# $1 : device type
# $2 : distribution
# $3 : variants
function generate_library(){
	if [ $2 == 'debian' ]; then
		lib_name="$1-python"
	else
		lib_name="$1-$2-python"
	fi
	path="$1/$2"

	cd $path
	versions=( */ )
	versions=( "${versions[@]%/}" )
	cd -

	echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>' > $lib_name

	for version in "${versions[@]}"; do
		commit="$(git log -1 --format='format:%H' -- "$path/$version")"
		fullVersion="$(grep -m1 'ENV PYTHON_VERSION ' "$path/$version/Dockerfile" | cut -d' ' -f3)"
		versionAliases=( $fullVersion $version ${aliases[$fullVersion]} )
		echo >> $lib_name
		for va in "${versionAliases[@]}"; do
			echo "$va: ${url}@${commit} $repo/$path/$version" >> $lib_name
		done
	
		for variant in $3; do
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
	done
}

declare -A aliases
aliases=(
	[2.7.11]='latest'
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"
repo=${PWD##*/}

devices=( */ )
devices=( "${devices[@]%/}" )
url='git://github.com/resin-io-library/base-images'
for device in "${devices[@]}"; do

	cd $device
	distros=( */ )
	distros=( "${distros[@]%/}" )
	cd ..
	for distro in "${distros[@]}"; do
		# Debian
		if [ $distro == 'debian' ]; then
			generate_library "$device" "$distro" "onbuild wheezy slim"
		fi
	done
done

