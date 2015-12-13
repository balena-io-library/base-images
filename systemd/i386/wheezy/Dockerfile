FROM resin/i386-debian:wheezy

RUN apt-get update && apt-get install -y --no-install-recommends \
    dropbear \
    curl \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#create the ssh keys dir with correct perms
RUN mkdir -p /root/.ssh
RUN chmod 700  /root/.ssh

RUN mkdir -p /usr/lib/resin
COPY entry.sh /usr/bin/entry.sh
COPY setup-ssh.sh /usr/lib/resin/setup-ssh.sh

ENTRYPOINT ["/usr/bin/entry.sh"]
