#!/bin/bash

HOSTNAME=$(cat /etc/hostname)-${RESIN_DEVICE_UUID:0:6}
echo $HOSTNAME > /etc/hostname
echo "127.0.1.1 $HOSTNAME" >> /etc/hosts
hostname $HOSTNAME

mount -t devtmpfs none /dev
udevd & 
udevadm trigger &> /dev/null
	
CMD=$(which $1)
shift
exec "$CMD" "$@"
