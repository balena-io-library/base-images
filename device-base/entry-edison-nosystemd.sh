#!/bin/bash

HOSTNAME=$(cat /etc/hostname)
echo "127.0.1.1 $HOSTNAME" >> /etc/hosts
hostname $HOSTNAME

mount -t devtmpfs none /dev
udevd & 
udevadm trigger &> /dev/null

# mount debugfs on /sys/kernel/debug so that libmraa can set/change pin modes on intel edison
mount -t debugfs nodev /sys/kernel/debug
	
CMD=$(which $1)
shift
exec "$CMD" "$@"
