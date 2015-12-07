#!/bin/bash

# Base on awesome script here: https://gist.github.com/cjus/1047794
extract_json_value() {
	# key
	key=$1
	# number of value we want to get if it's multiple value
	num=$2
	awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p
}

# Default ssh password will be `resin` if SSH_PASSWORD environment variable is not defined.
if [ -z "$SSH_PASSWORD" ]; then
	echo "root:resin" | chpasswd
else
	echo "root:$SSH_PASSWORD" | chpasswd
fi

# Automatically download ssh keys if RESIN_API_KEY or AUTH_TOKEN environment variable is defined.
if [ ! -z "$AUTH_TOKEN" ] || [ ! -z "$RESIN_API_KEY" ]; then
	if [ -z "$RESIN_API_KEY" ]; then
		# Use Auth Token to download SSH keys from Resin API
		curl -s -H "Authorization: Bearer $AUTH_TOKEN" 'https://api.resin.io/ewa/user__has__public_key?$select=id,title,public_key' &> /dev/null | extract_json_value 'public_key' > /data/ssh_keys
	else
		# Use Resin API Key to download SSH keys from Resin API
		curl -s "https://api.resin.io/ewa/user__has__public_key?apikey=$RESIN_API_KEY&\$select=id,title,public_key" &> /dev/null | extract_json_value 'public_key' > /data/ssh_keys
	fi

	cp -rf /data/ssh_keys /root/.ssh/authorized_keys
	chmod 640  /root/.ssh/authorized_keys
fi

# Default ssh port will be 80 if SSH_PORT enviroment variable is not defined.
if [ -z "$SSH_PORT" ]; then
	export SSH_PORT=80
fi

# Check if it's a systemd based system.
if [ -d "/usr/lib/systemd" ]; then 
	sed -ri "s/^ListenStream=\s+.*/ListenStream=$SSH_PORT/" /lib/systemd/system/ssh.socket
	sed -i "s/sshd -D \$SSHD_OPTS/sshd -D -p$SSH_PORT \$SSHD_OPTS/" /lib/systemd/system/ssh.service
fi

if [ "$INITSYSTEM" != "on" ]; then
	/usr/sbin/sshd -p $SSH_PORT &
fi
