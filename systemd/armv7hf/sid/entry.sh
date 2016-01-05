#!/bin/bash

# remove all shells (ex: sh -c , bash -c, /bin/bash -c, /bin/sh -c), keep the command and arguments only
parse_args() {
    shells="/bin/bash /bin/sh /usr/bin/zsh"
    args=( "$@" )

    while true; do
            [[ $shells =~ ${args[0]} ]] \
            && {
                    if [ ${args[1]} = "-c" ]; then
                            args=( "${args[@]:2}" )
                    fi
                    break
            } ||    break
    done
    echo "${args[@]}"
}


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

if [ "$INITSYSTEM" = "on" ]; then
	GREEN='\033[0;32m'
	echo -e "${GREEN}Systemd init system enabled."
	env > /etc/docker.env

	args=($(parse_args $@))
	CMD=$(which "${args[0]}")
	echo -e "#!/bin/bash\n$CMD "$(printf '%q ' ${args[@]:1}) > /etc/resinApp.sh
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
