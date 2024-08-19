#!/bin/bash

# This command only works in privileged container
tmp_mount='/tmp/_balena'
mkdir -p "$tmp_mount"
if mount -t devtmpfs none "$tmp_mount" &> /dev/null; then
	PRIVILEGED=true
	umount "$tmp_mount"
else
	PRIVILEGED=false
fi
rm -rf "$tmp_mount"

function mount_dev()
{
	tmp_dir='/tmp/tmpmount'
	mkdir -p "$tmp_dir"
	mount -t devtmpfs none "$tmp_dir"
	mkdir -p "$tmp_dir/shm"
	mount --move /dev/shm "$tmp_dir/shm"
	mkdir -p "$tmp_dir/mqueue"
	mount --move /dev/mqueue "$tmp_dir/mqueue"
	mkdir -p "$tmp_dir/pts"
	mount --move /dev/pts "$tmp_dir/pts"
	touch "$tmp_dir/console"
	mount --move /dev/console "$tmp_dir/console"
	umount /dev || true
	mount --move "$tmp_dir" /dev

	# Since the devpts is mounted with -o newinstance by Docker, we need to make
	# /dev/ptmx point to its ptmx.
	# ref: https://www.kernel.org/doc/Documentation/filesystems/devpts.txt
	ln -sf /dev/pts/ptmx /dev/ptmx

	# When using io.balena.features.sysfs the mount point will already exist
	# we need to check the mountpoint first.
	sysfs_dir='/sys/kernel/debug'

	if ! mountpoint -q "$sysfs_dir"; then
		mount -t debugfs nodev "$sysfs_dir"
	fi

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
	# echo error message, when executable file is passed but doesn't exist.
	if [ -n "$1" ]; then
		if CMD=$(command -v "$1" 2>/dev/null); then
			shift
			exec "$CMD" "$@"
		else
			echo "Command not found: $1"
			exit 1
		fi
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
