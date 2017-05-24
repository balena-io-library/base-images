#!/bin/bash
set -o pipefail

# Generate library file.
# $1 : device type
# $2 : distribution
# $3 : variants
function generate_library(){
	if [ $2 == 'debian' ]; then
		lib_name="$1-node"
	else
		lib_name="$1-$2-node"
	fi
	path="$1/$2"

	cd $path
	versions=( */ )
	versions=( "${versions[@]%/}" )
	cd -

	url='git://github.com/resin-io-library/base-images'
	echo '# maintainer: Joyent Image Team <image-team@joyent.com> (@joyent)' > $lib_name
	echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>' >> $lib_name

	for version in "${versions[@]}"; do
		commit="$(git log -1 --format='format:%H' -- "$path/$version")"
		fullVersion="$(find "$path/$version" -name 'Dockerfile' -exec bash -c 'grep -m1 "ENV NODE_VERSION " "$0" | cut -d" " -f3; kill "$PPID"' {} \;)"
		if [ $version == 'default' ]; then
			versionAliases=( $fullVersion )
		else
			versionAliases=( $fullVersion $version ${aliases[$fullVersion]} )
		fi

		if [ $1 == 'raspberrypi' ] && [ $2 == 'debian' ] && [ $version == '0.12' ]; then
			continue
		fi

		if [ -f "$path/$version/Dockerfile" ]; then
			echo >> $lib_name
			for va in "${versionAliases[@]}"; do
				echo "$va: ${url}@${commit} $repo/$path/$version" >> $lib_name
			done
		fi

		for variant in $3; do
			if [ -d "$path/$version/$variant" ]; then
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
			fi
		done
	done
}

declare -A aliases
aliases=(
	[7.10.0]='7 latest'
	[6.10.3]='6'
	[6.3.1]='6 latest'
	[5.12.0]='5'
	[4.8.3]='4'
	[0.12.18]='0'
)

defaultVersion='0.10.22'

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

repo=${PWD##*/}

devices=( "$@" )
if [ ${#devices[@]} -eq 0 ]; then
	devices=( */ )
fi
devices=( "${devices[@]%/}" )

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
		# Alpine
		if [ $distro == 'alpine' ]; then
			generate_library "$device" "$distro" "onbuild edge slim"
		fi
		# Fedora
		if [ $distro == 'fedora' ]; then
			generate_library "$device" "$distro" "onbuild 23 slim"
		fi
	done
done
