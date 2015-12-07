FROM resin/amd64-debian:wheezy

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
COPY setup-ssh.sh /usr/lib/resin/setup-ssh.sh

ENTRYPOINT ["/usr/bin/entry.sh"]
