FROM arm64v8/fedora:25
LABEL io.resin.architecture="aarch64"
 
LABEL io.resin.qemu.version="3.0.0+resin-aarch64"
COPY qemu-aarch64-static /usr/bin 

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
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v0.14.0/tini0.14.0.linux-aarch64.tar.gz" \
  && echo "edddd28f0c683773670592f6013f5eadb96bbf62a100f3d7d6c58e6a5cb248b4  tini0.14.0.linux-aarch64.tar.gz" | sha256sum -c - \
  && tar -xzf "tini0.14.0.linux-aarch64.tar.gz" \
  && rm "tini0.14.0.linux-aarch64.tar.gz" \
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