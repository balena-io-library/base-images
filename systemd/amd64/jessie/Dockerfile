FROM resin/amd64-debian:jessie

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
    openssh-server \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#create the ssh keys dir with correct perms
RUN mkdir -p /root/.ssh
RUN chmod 700  /root/.ssh

RUN mkdir -p /usr/lib/resin
COPY entry.sh /usr/bin/entry.sh    
COPY launch.service /etc/systemd/system/launch.service
COPY setup-ssh.sh /usr/lib/resin/setup-ssh.sh

RUN systemctl enable /etc/systemd/system/launch.service

ENTRYPOINT ["/usr/bin/entry.sh"]
