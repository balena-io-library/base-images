#!/bin/bash

set -e

function test_hello_world {
    local result

    if [ -z ${DOTNET_SDK_VERSION+x} ]; then
    	echo "No .NET hello world test, skipping..."; exit 0
    else
        if [ -z "$(dotnet --list-sdks)" ] ; then
             echo ".NET SDK should be installed, and isn't." ; exit 1
        fi
        dotnet new console -o testApp
        cd testApp
        result=$(dotnet run)
        cd ..
        rm -rf testApp
        [[ "$result" == *"Hello"* ]] || ( echo ".NET hello world test failed." ; exit 1 )
        echo ".NET hello test passed!"
    fi
}

function main {
    test_hello_world
}

main
