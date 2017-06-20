#!/bin/bash

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

function init_openrc()
{
	GREEN='\033[0;32m'
	echo -e "${GREEN}OpenRC init system enabled."
	env >> /etc/docker.env
	printf '#!/bin/bash\n exec ' > /etc/resinApp.sh
	printf '%q ' "$@" >> /etc/resinApp.sh
	chmod +x /etc/resinApp.sh

	sed -i -e s~#{DIR}~"$(pwd)"~g \
		-e s~#{ENV}~"$(env | tr '\n' ' ' | xargs printf '--env "%s" ')"~g /etc/init.d/resin

	exec /sbin/init quiet
}

function init_non_openrc()
{
	udevd & 
	udevadm trigger &> /dev/null
	
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

INITSYSTEM=$(echo "$INITSYSTEM" | awk '{print tolower($0)}')

case "$INITSYSTEM" in
	'1' | 'true')
		INITSYSTEM='on'
	;;
esac

if [ ! -z "$RESIN_SUPERVISOR_API_KEY" ] && [ ! -z "$RESIN_DEVICE_UUID" ]; then
	# run this on resin device only
	update_hostname
	mount_dev
fi 

if [ "$INITSYSTEM" = "on" ]; then
	init_openrc "$@"
else
	init_non_openrc "$@"
fi
