FROM resin/armv7hf-debian:wheezy

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
COPY setup-ssh.sh /usr/lib/resin/setup-ssh.sh
COPY setup-resin-sync.sh /usr/lib/resin/setup-resin-sync.sh

ENTRYPOINT ["/usr/bin/entry.sh"]
