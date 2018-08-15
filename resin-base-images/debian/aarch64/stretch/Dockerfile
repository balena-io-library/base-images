FROM arm64v8/debian:stretch-slim
LABEL io.resin.architecture="aarch64"
 
LABEL io.resin.qemu.version="3.0.0+resin-aarch64"
COPY qemu-aarch64-static /usr/bin 

RUN apt-get update && apt-get install -y --no-install-recommends \
  sudo \
  ca-certificates \
  findutils \
  gnupg \
  dirmngr \
  inetutils-ping \
  netbase \
  curl \
  udev \
  $( \
      if apt-cache show 'iproute' 2>/dev/null | grep -q '^Version:'; then \
        echo 'iproute'; \
      else \
        echo 'iproute2'; \
      fi \
  ) \
  && rm -rf /var/lib/apt/lists/*

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

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
# For backward compatibility, udev is enabled by default
ENV UDEV on

# 01_nodoc
RUN echo 'path-exclude /usr/share/doc/*\n\
# we need to keep copyright files for legal reasons\n\
path-include /usr/share/doc/*/copyright\n\
path-exclude /usr/share/man/*\n\
path-exclude /usr/share/groff/*\n\
path-exclude /usr/share/info/*\n\
path-exclude /usr/share/lintian/*\n\
path-exclude /usr/share/linda/*\n\
path-exclude /usr/share/locale/*\n\
path-include /usr/share/locale/en*' > /etc/dpkg/dpkg.cfg.d/01_nodoc

# 01_buildconfig
RUN echo 'APT::Get::Assume-Yes "true";\n\
APT::Install-Recommends "0";\n\
APT::Install-Suggests "0";\n\
quiet "true";' > /etc/apt/apt.conf.d/01_buildconfig

RUN mkdir -p /usr/share/man/man1

# Install Systemd

RUN apt-get update && apt-get install -y --no-install-recommends \
        systemd \
        systemd-sysv \
    && rm -rf /var/lib/apt/lists/*

ENV container docker

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
    graphical.target \
    kmod-static-nodes.service

COPY entry.sh /usr/bin/entry.sh

# launch.service
RUN echo '[Unit]\n\
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

RUN systemctl enable launch.service

STOPSIGNAL 37
ENTRYPOINT ["/usr/bin/entry.sh"]