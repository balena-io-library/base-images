FROM fedora:26

LABEL LABEL io.resin.architecture="amd64"


COPY resin-xbuild /usr/bin/
RUN ln -s resin-xbuild /usr/bin/cross-build-start \
    && ln -s resin-xbuild /usr/bin/cross-build-end

# For backward compatibility, udev is enabled by default
ENV UDEV on

RUN dnf update -y \
    && dnf install -y \
        ca-certificates \
        tar \
        systemd \
        udev \
        which \
        hostname \
        curl \
    && dnf clean all

# Tini
ENV TINI_VERSION 0.14.0
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/tini0.14.0.linux-amd64.tar.gz" \
    && echo "a662ee1594cb037909237c87d577b6e4dee9879f1c23279f1a829683e542e4a0 tini0.14.0.linux-amd64.tar.gz" | sha256sum -c - \
    && tar -xzf "tini0.14.0.linux-amd64.tar.gz" \
    && rm "tini0.14.0.linux-amd64.tar.gz" \
    && chmod +x tini \
    && mv tini /sbin/tini

# Install Systemd
ENV container docker

# We only want few core services run in the container.
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
        systemd-vconsole-setup.service \
        kmod-static-nodes.service

COPY entry.sh /usr/bin/entry.sh
COPY launch.service /etc/systemd/system/launch.service

RUN systemctl enable launch.service

STOPSIGNAL 37

ENTRYPOINT ["/usr/bin/entry.sh"]
