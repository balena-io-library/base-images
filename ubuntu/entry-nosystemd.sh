#!/bin/bash

hostname "$HOSTNAME" &> /dev/null
if [[ $? == 0 ]]; then
	PRIVILEGED=true
else
	PRIVILEGED=false
fi

function start_udev()
{
	if [ "$UDEV" == "on" ]; then
		if [ "$INITSYSTEM" != "on" ]; then
			which udevd
			if [ $? == '0' ]; then
				udevd --daemon &> /dev/null
			else
				/lib/systemd/systemd-udevd --daemon &> /dev/null
			fi
			udevadm trigger &> /dev/null
		fi
	fi
}

function remove_buildtime_env_var()
{
	unset QEMU_CPU
}

# On ResinOS 2.x devices, the hostname is set by the hostOS.
# For backward compatibility, we only update the hostname for ResinOS 1.x devices.
function update_hostname()
{
	if [ ${RESIN_DEVICE_UUID:0:7} != ${HOSTNAME:0:7} ]; then
		# For 1.x Devices only.
		HOSTNAME="$RESIN_DEVICE_TYPE-${RESIN_DEVICE_UUID:0:7}"
		echo $HOSTNAME > /etc/hostname
		echo "127.0.1.1 $HOSTNAME" >> /etc/hosts
		hostname "$HOSTNAME"
	fi
}

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

function init_non_systemd()
{
	CMD=$(which "$1")
	# echo error message, when executable file doesn't exist.
	if [ $? == '0' ]; then
		shift
		exec tini -sg -- "$CMD" "$@"
	else
		echo "Command not found: $1"
		exit 1
	fi
}

remove_buildtime_env_var

INITSYSTEM=$(echo "$INITSYSTEM" | awk '{print tolower($0)}')

case "$INITSYSTEM" in
	'1' | 'true')
		INITSYSTEM='on'
	;;
esac

UDEV=$(echo "$UDEV" | awk '{print tolower($0)}')

case "$UDEV" in
	'1' | 'true')
		UDEV='on'
	;;
esac

if [ ! -z "$RESIN_SUPERVISOR_API_KEY" ] && [ ! -z "$RESIN_DEVICE_UUID" ]; then
	# run this on resin device only

	if $PRIVILEGED; then
		# Only run this in privileged container
		update_hostname
		mount_dev
	fi
	start_udev
fi 

init_non_systemd "$@"
