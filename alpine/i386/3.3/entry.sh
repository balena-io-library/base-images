#!/bin/bash

HOSTNAME=$(cat /etc/hostname)-${RESIN_DEVICE_UUID:0:6}
echo $HOSTNAME > /etc/hostname
echo "127.0.1.1 $HOSTNAME" >> /etc/hosts
hostname $HOSTNAME

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

if [ "$INITSYSTEM" = "on" ]; then
	GREEN='\033[0;32m'
	echo -e "${GREEN}OpenRC init system enabled."
	env >> /etc/docker.env
	printf '#!/bin/bash\n exec ' > /etc/resinApp.sh
	printf '%q ' "$@" >> /etc/resinApp.sh
	chmod +x /etc/resinApp.sh

	sed -i -e s~#{DIR}~"$(pwd)"~g \
		-e s~#{ENV}~"$(env | sed '/PATH=/d'  | tr '\n' ' ' | xargs printf '--env %s ')"~g /etc/init.d/resin

	exec /sbin/init quiet
else
	udevd & 
	udevadm trigger &> /dev/null
	
	CMD=$(which $1)
	# echo error message, when executable file doesn't exist.
	if [  $? == '0' ]; then
		shift
		exec "$CMD" "$@"
	else
		echo "Command not found: $1"
		exit 1
	fi
fi

