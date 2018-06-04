FROM fedora:26
LABEL io.resin.architecture="amd64"

RUN dnf update -y && dnf install -y \
  ca-certificates \
  findutils \
  hostname \
  systemd \
  tar \
  udev \
  which \
  curl \
  && dnf clean all

RUN curl -SLO "http://resin-packages.s3.amazonaws.com/resin-xbuild/v1.0.0/resin-xbuild1.0.0.tar.gz" \
  && echo "1eb099bc3176ed078aa93bd5852dbab9219738d16434c87fc9af499368423437  resin-xbuild1.0.0.tar.gz" | sha256sum -c - \
  && tar -xzf "resin-xbuild1.0.0.tar.gz" \
  && rm "resin-xbuild1.0.0.tar.gz" \
  && chmod +x resin-xbuild \
  && mv resin-xbuild /usr/bin \
  && ln -s resin-xbuild /usr/bin/cross-build-start \
  && ln -s resin-xbuild /usr/bin/cross-build-end

ENV TINI_VERSION 0.14.0
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v0.14.0/tini0.14.0.linux-amd64.tar.gz" \
  && echo "a662ee1594cb037909237c87d577b6e4dee9879f1c23279f1a829683e542e4a0  tini0.14.0.linux-amd64.tar.gz" | sha256sum -c - \
  && tar -xzf "tini0.14.0.linux-amd64.tar.gz" \
  && rm "tini0.14.0.linux-amd64.tar.gz" \
  && chmod +x tini \
  && mv tini /sbin/tini

# For backward compatibility, udev is enabled by default
ENV UDEV on

ENV container docker

RUN systemctl mask \
        dev-hugepages.mount \
        sys-fs-fuse-connections.mount \
        sys-kernel-config.mount \
        display-manager.service \
        getty@.service \
        systemd-logind.service \
        systemd-remount-fs.service \
        getty.target \
        graphical.target \
        console-getty.service \
        systemd-vconsole-setup.service

COPY entry.sh /usr/bin/

# launch.service
RUN echo $'[Unit]\n\
Description=Resin.io User Application\n\
\n\
[Service]\n\
EnvironmentFile=/etc/docker.env\n\
ExecStart=/etc/resinApp.sh\n\
StandardOutput=tty\n\
StandardError=tty\n\
TTYPath=/dev/console\n\
Restart=on-failure\n\
\n\
[Install]\n\
WantedBy=basic.target' > /etc/systemd/system/launch.service

RUN systemctl enable launch.service systemd-udevd

STOPSIGNAL 37
ENTRYPOINT ["/usr/bin/entry.sh"]