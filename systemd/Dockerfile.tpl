FROM #{FROM}

# Install Systemd

ENV container lxc

# We never want these to run in a container
RUN systemctl mask \
    dev-hugepages.mount \
    sys-fs-fuse-connections.mount \
    sys-kernel-config.mount \

    display-manager.service \
    getty@.service \
    systemd-logind.service \
    systemd-remount-fs.service \

    getty.target \
    graphical.target

RUN apt-get update && apt-get install -y --no-install-recommends \
    dropbear \
    curl \
    ca-certificates \
    rsync \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#create the ssh keys dir with correct perms
RUN mkdir -p /root/.ssh
RUN chmod 700  /root/.ssh

RUN mkdir -p /usr/lib/resin
COPY entry.sh /usr/bin/entry.sh    
COPY launch.service /etc/systemd/system/launch.service
COPY setup-ssh.sh /usr/lib/resin/setup-ssh.sh
COPY setup-resin-sync.sh /usr/lib/resin/setup-resin-sync.sh

RUN systemctl enable /etc/systemd/system/launch.service

ENTRYPOINT ["/usr/bin/entry.sh"]
