#!/bin/bash

set -e

function check_vesion {
    local queried_go_version

    [ -n "$GO_VERSION" ] || ( echo "No GO_VERSION env var!" ; exit 1 )
    queried_go_version=$(go version)
    [[ "${queried_go_version}" == *" go$GO_VERSION "* ]] || ( echo "Go version doesn't match." ; exit 1 )
    echo "Go version test passed!"
}

function test_go_get {
    local result

    go get github.com/golang/example/hello

    result=$(hello)
    rm -rf $GOPATH/bin/* $GOPATH/src/*
    [ "$result" == "Hello, Go examples!" ] || ( echo "Go get & run failed." ; exit 1)
    echo "Go get test passed!"
}

function test_hello_world {
    local expected_std_out="Hello World!"

    cat << EOF > hello.go
package main
import "fmt"
func main() {
    fmt.Printf("Hello World!")
}
EOF
    result=$(go run ./hello.go)
    rm -rf hello.go
    [ "$result" == "$expected_std_out" ] || ( echo "Go hello world test failed." ; exit 1)
    echo "Go hello test passed!"
}

function main {
    check_vesion
    test_go_get
    test_hello_world
}

main
