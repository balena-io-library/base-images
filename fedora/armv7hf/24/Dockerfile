FROM arm32v7/fedora:24

LABEL LABEL io.resin.architecture="armv7hf" io.resin.qemu.version="2.9.0.resin1-arm"

COPY qemu-arm-static /usr/bin/qemu-arm-static
COPY resin-xbuild /usr/bin/
RUN ln -s resin-xbuild /usr/bin/cross-build-start \
    && ln -s resin-xbuild /usr/bin/cross-build-end

# Few tweaks for Fedora base image
RUN mkdir -p /etc/dnf/vars \
    && echo "armhfp" > /etc/dnf/vars/basearch \
    && echo "armv7hl" > /etc/dnf/vars/arch

RUN dnf update -y \
    && dnf install -y \
        ca-certificates \
        findutils \
        hostname \
        systemd \
        tar \
        udev \
        which \
        curl \
    && dnf clean all

# Tini
ENV TINI_VERSION 0.14.0
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/tini0.14.0.linux-armv7hf.tar.gz" \
    && echo "cab86b2ad88ae6a3ef649293a5fecbc55bc31722cc8220f7b82bd6c960553e44 tini0.14.0.linux-armv7hf.tar.gz" | sha256sum -c - \
    && tar -xzf "tini0.14.0.linux-armv7hf.tar.gz" \
    && rm "tini0.14.0.linux-armv7hf.tar.gz" \
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
VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT ["/usr/bin/entry.sh"]
