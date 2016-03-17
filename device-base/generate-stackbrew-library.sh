#!/bin/bash
set -e

declare -A aliases
aliases=(
	[jessie]='latest'
	[3.3]='latest'
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
		if [ $suite == 'alpine' ]; then
			cd $device/$suite
			alpine_suites=( */ )
			alpine_suites=( "${alpine_suites[@]%/}" )
			cd -
			for alpine_suite in "${alpine_suites[@]}"; do
				alpine_suiteAliases=( $alpine_suite ${aliases[$alpine_suite]} )

				commit="$(git log -1 --format='format:%H' -- "$device/$suite/$alpine_suite")"
				echo
				for va in "${alpine_suiteAliases[@]}"; do
					echo "$va: ${url}@${commit} $repo/$device/$suite/$alpine_suite"
				done
			done
		else
			suiteAliases=( $suite ${aliases[$suite]} )

			commit="$(git log -1 --format='format:%H' -- "$device/$suite")"
			echo
			for va in "${suiteAliases[@]}"; do
				echo "$va: ${url}@${commit} $repo/$device/$suite"
			done
		fi
	done
done

