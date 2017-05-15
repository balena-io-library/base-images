#!/bin/bash
set -e

# get test case from last commit message.

targetCommit=$(git rev-parse "$GIT_COMMIT"^2)
testCase=$(git log $targetCommit -1 --pretty=%B | grep '^Test-case:' | sed 's/^Test-case://g')

if [ -z "$testCase" ]; then
	# If no test case included.
	echo "No test case included. Skip the test!"
	exit 0
else
	while IFS= read -r dockerfile || [[ -n "$dockerfile" ]]; do
		if ! (
			set -x
			echo "Building $dockerfile!"
			docker build --pull -t test-image "$dockerfile"
		); then
			echo "Building $dockerfile failed!"
			didFail=1
			continue
		fi
	done <"$testCase"
	docker rmi -f test-image || true
fi

[ -z "$didFail" ]
