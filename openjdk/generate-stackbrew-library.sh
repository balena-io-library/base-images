#!/bin/bash
set -o pipefail

aliases() {
	local javaVersion="$1"; shift
	local javaType="$1"; shift
	local fullVersion="$1"; shift
	local variant="$1" # optional

	bases=( $fullVersion )
	if [ "${fullVersion%-*}" != "$fullVersion" ]; then
		bases+=( ${fullVersion%-*} ) # like "8u40-b09
	fi
	if [ "$javaVersion" != "${fullVersion%-*}" ]; then
		bases+=( $javaVersion )
	fi

	versionAliases=()
	for base in "${bases[@]}"; do
		versionAliases+=( "$base-$javaType" )
		if [ "$javaType" = "$defaultType" ]; then
			versionAliases+=( "$base" )
		fi
	done

	# add "openjdk" prefixes
	openjdkPrefix=( "${versionAliases[@]/#/openjdk-}" )

	# add aliases and the prefixed versions (so the silly prefix versions come dead last)
	versionAliases+=( ${aliases[$javaVersion-$javaType]} "${openjdkPrefix[@]}" )

	if [ "$variant" ]; then
		versionAliases=( "${versionAliases[@]/%/-$variant}" )
		versionAliases=( "${versionAliases[@]//latest-/}" )
	fi

	echo "${versionAliases[@]}"
}

# Generate library file.
# $1 : device type
# $2 : distribution
function generate_library(){
	if [ $2 == 'debian' ]; then
		lib_name="$1-openjdk"
	else
		lib_name="$1-$2-openjdk"
	fi
	path="$1/$2"

	cd $path
	versions=( */ )
	versions=( "${versions[@]%/}" )
	cd -

	url='git://github.com/resin-io-library/base-images'
	echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>' >> $lib_name

	for version in "${versions[@]}"; do
		commit="$(git log -1 --format='format:%H' -- "$path/$version")"

		javaVersion="$version" # "6-jdk"
		javaType="${javaVersion##*-}" # "jdk"
		javaVersion="${javaVersion%-$javaType}" # "6"

		fullVersion="$(grep -m1 'ENV JAVA_VERSION ' "$path/$version/Dockerfile" | cut -d' ' -f3 | tr '~' '-')"

		versionAliases=( $(aliases "$javaVersion" "$javaType" "$fullVersion") )

		if [ -f "$path/$version/Dockerfile" ]; then
			echo >> $lib_name
			for va in "${versionAliases[@]}"; do
				echo "$va: ${url}@${commit} $repo/$path/$version" >> $lib_name
			done
		fi
	done
}

declare -A aliases
aliases=(
	[8-jdk]='jdk latest'
	[8-jre]='jre'
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
		generate_library "$device" "$distro"
	done
done
