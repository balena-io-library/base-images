#!/bin/bash

HOSTNAME=$(cat /etc/hostname)-${RESIN_DEVICE_UUID:0:6}
echo $HOSTNAME > /etc/hostname
echo "127.0.1.1 $HOSTNAME" >> /etc/hosts
hostname $HOSTNAME

mkdir -p /tmp/pts
mount --move /dev/pts /tmp/pts

mount -t devtmpfs none /tmp

mkdir -p /tmp/shm
mount --move /dev/shm /tmp/shm
mkdir -p /tmp/mqueue
mount --move /dev/mqueue /tmp/mqueue
touch /tmp/console
mount --move /dev/console /tmp/console
umount /dev || true
mount --move /tmp /dev
mount -t debugfs nodev /sys/kernel/debug
udevd &
udevadm trigger &> /dev/null

CMD=$(which $1)
shift
exec "$CMD" "$@"
