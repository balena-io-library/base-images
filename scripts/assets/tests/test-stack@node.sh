#!/bin/bash

set -e

function check_version {
    local queried_node_version
    local queried_yarn_version

    [ -n "$NODE_VERSION" ] || ( echo "No NODE_VERSION env var!" ; exit 1 )
    queried_node_version=$(node --version)
    [ "${queried_node_version}" == "v${NODE_VERSION}" ] || ( echo "Node version doesn't match." ; exit 1 )

    [ -n "$YARN_VERSION" ] || ( echo "No YARN_VERSION env var!" ; exit 1 )
    queried_yarn_version=$(yarn --version)
    [ "${queried_yarn_version}" == "${YARN_VERSION}" ] || ( echo "Yarn version doesn't match." ; exit 1)
    echo "Node version test passed!"
}

function test_hello_world {
    local expected_std_out="Hello World!"

    echo "console.log(\"$expected_std_out\");" > hello.js

    result=$(node ./hello.js)
    rm -rf hello.js
    [ "$result" == "$expected_std_out" ] || ( echo "Node hello world test failed." ; exit 1)
    echo "Node hello test passed!"
}

function main {
	check_version
	test_hello_world
}

main
