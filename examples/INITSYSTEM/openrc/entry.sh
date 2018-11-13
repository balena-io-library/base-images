#!/bin/bash

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

if [ "$INITSYSTEM" = "on" ]; then
	init_openrc "$@"
else
	init_non_openrc "$@"
fi
