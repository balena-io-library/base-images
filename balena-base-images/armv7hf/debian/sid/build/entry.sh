#!/bin/bash

hostname "$HOSTNAME" &> /dev/null
if [[ $? == 0 ]]; then
	PRIVILEGED=true
else
	PRIVILEGED=false
fi

function mount_dev()
{
	mkdir -p /tmp
	mount -t devtmpfs none /tmp
	mkdir -p /tmp/shm
	mount --move /dev/shm /tmp/shm
	mkdir -p /tmp/mqueue
	mount --move /dev/mqueue /tmp/mqueue
	mkdir -p /tmp/pts
	mount --move /dev/pts /tmp/pts
	touch /tmp/console
	mount --move /dev/console /tmp/console
	umount /dev || true
	mount --move /tmp /dev

	# Since the devpts is mounted with -o newinstance by Docker, we need to make
	# /dev/ptmx point to its ptmx.
	# ref: https://www.kernel.org/doc/Documentation/filesystems/devpts.txt
	ln -sf /dev/pts/ptmx /dev/ptmx
	mount -t debugfs nodev /sys/kernel/debug
}

function start_udev()
{
	if [ "$UDEV" == "on" ]; then
		if $PRIVILEGED; then
			mount_dev
			if command -v udevd &>/dev/null; then
				unshare --net udevd --daemon &> /dev/null
			else
				unshare --net /lib/systemd/systemd-udevd --daemon &> /dev/null
			fi
			udevadm trigger &> /dev/null
		else
			echo "Unable to start udev, container must be run in privileged mode to start udev!"
		fi
	fi
}

function init()
{
	# echo error message, when executable file doesn't exist.
	if CMD=$(command -v "$1" 2>/dev/null); then
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
