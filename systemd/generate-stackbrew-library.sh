#!/bin/bash
set -e

declare -A aliases
aliases=(
	[jessie]='latest'
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE[0]")")"

repos=( "$@" )
if [ ${#repos[@]} -eq 0 ]; then
	repos=( */ )
fi
repos=( "${repos[@]%/}" )

echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>'

for repo in "${repos[@]}"; do

	cd $repo
	versions=( "$@" )
	if [ ${#versions[@]} -eq 0 ]; then
		versions=( */ )
	fi
	versions=( "${versions[@]%/}" )
	cd ..
	url='git://github.com/nghiant2710/image-tree'
	for version in "${versions[@]}"; do
		versionAliases=( $version ${aliases[$version]} )
		commit="$(git log -1 --format='format:%H' -- "$repo/$version")"
		echo
		for va in "${versionAliases[@]}"; do
			echo "$va: ${url}@${commit} $repo/$version"
		done
	done
done
