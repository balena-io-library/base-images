#!/bin/bash

HOSTNAME=$HOSTNAME-${RESIN_DEVICE_UUID:0:6}
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

if [ "$INITSYSTEM" = "on" ]; then
	GREEN='\033[0;32m'
	echo -e "${GREEN}Systemd init system enabled."
	env > /etc/docker.env

	printf '#!/bin/bash\n exec ' > /etc/resinApp.sh
	printf '%q ' "$@" >> /etc/resinApp.sh
	chmod +x /etc/resinApp.sh

	mkdir -p /etc/systemd/system/launch.service.d
	cat <<-EOF > /etc/systemd/system/launch.service.d/override.conf
		[Service]
		WorkingDirectory=$(pwd)
	EOF

	exec /sbin/init quiet systemd.show_status=0
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
