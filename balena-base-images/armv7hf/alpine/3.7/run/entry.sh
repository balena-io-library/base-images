#!/bin/bash

function start_udev()
{
	if [ "$UDEV" == "on" ]; then
		udevd --daemon &> /dev/null
		udevadm trigger &> /dev/null
	fi
}

function init()
{
	CMD=$(which "$1")
	# echo error message, when executable file doesn't exist.
	if [ $? == '0' ]; then
		shift
		exec "$CMD" "$@"
	else
		echo "Command not found: $1"
		exit 1
	fi
}

UDEV=$(echo "$UDEV" | awk '{print tolower($0)}')

case "$UDEV" in
	'1' | 'true')
		UDEV='on'
	;;
esac

start_udev
init "$@"
