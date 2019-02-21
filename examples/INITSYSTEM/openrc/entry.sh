#!/bin/bash

if hostname "$HOSTNAME" &> /dev/null; then
	PRIVILEGED=true
else
	PRIVILEGED=false
fi

function start_udev()
{
	if [ "$UDEV" == "on" ]; then
		if [ "$INITSYSTEM" == "on" ]; then
			rc-update add udev default
		else
			unshare --net udevd --daemon &> /dev/null
			udevadm trigger &> /dev/null
		fi
	fi
}

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

	# Make sure there is no pidfile before starting.
	if [ -f "/var/run/resinapp.pid" ]; then
		rm -f /var/run/resinapp.pid &> /dev/null
	fi

	sed -i -e s~#{DIR}~"$(pwd)"~g /etc/init.d/resin

	exec /sbin/init quiet
}

function init_non_openrc()
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

INITSYSTEM=$(echo "$INITSYSTEM" | awk '{print tolower($0)}')

case "$INITSYSTEM" in
	'1' | 'true')
		INITSYSTEM='on'
	;;
esac

if $PRIVILEGED; then
	# Only run this in privileged container
	mount_dev
	start_udev
fi

if [ "$INITSYSTEM" = "on" ]; then
	init_openrc "$@"
else
	init_non_openrc "$@"
fi
