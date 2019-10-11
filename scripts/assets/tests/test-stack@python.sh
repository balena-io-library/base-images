#!/bin/bash

set -e

function check_version {
    source /etc/os-release
    if [ "$ID" == "fedora" ] ; then
        echo "No Python version check for Fedora, skipping test..."; exit 0
    fi

    local queried_python_version
    local queried_pip_version
    local queried_setuptools_version

    [ -n "$PYTHON_VERSION" ] || ( echo "No PYTHON_VERSION env var!" ; exit 1 )
    # Python 2 prints version on STDERR, while Python 3 on STDOUT
    queried_python_version=$(python --version 2>&1)
    [ "${queried_python_version}" == "Python ${PYTHON_VERSION}" ] || ( echo "Python version doesn't match." ; exit 1 )

    [ -n "$PYTHON_PIP_VERSION" ] || ( echo "No PYTHON_PIP_VERSION env var!" ; exit 1 )
    queried_pip_version=$(pip --version)
    [[ "${queried_pip_version}" == "pip ${PYTHON_PIP_VERSION}"* ]] || ( echo "Pip version doesn't match." ; exit 1 )

    [ -n "$SETUPTOOLS_VERSION" ] || ( echo "No SETUPTOOLS_VERSION env var!" ; exit 1 )
    queried_setuptools_version=$(python -c "import setuptools; print(setuptools.__version__)")
    [ "${queried_setuptools_version}" == "${SETUPTOOLS_VERSION}" ] || ( echo "Setuptools version doesn't match." ; exit 1 )
    echo "Python version test passed!"
}

function test_python_pip_requests_ssl {
    local exit_code

    cat << EOF > request.py
import requests
r = requests.get('https://google.com')
assert(r.status_code == 200)
EOF

    pip install requests
    pip freeze > deps-list

    if python ./request.py &> /dev/null; then
        echo "Python pip requests ssl test passed!"
        exit_code=0
    else
        echo "Python pip requests ssl test failed."
        exit_code=1
    fi

    pip uninstall -y -r deps-list
    rm -rf request.py deps-list
    exit $exit_code
}

function test_hello_world {
    local expected_std_out="Hello World!"

    result=$(python - <<EOF
print("Hello World!")
EOF
    )
    [ "$result" == "$expected_std_out" ] || ( echo "Python hello world test failed." ; exit 1)
    echo "Python hello test passed!"
}


function main {
    check_version
    test_hello_world
    test_python_pip_requests_ssl
}

main
