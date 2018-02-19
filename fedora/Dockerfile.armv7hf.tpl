FROM #{FROM}

LABEL #{LABEL}

#{QEMU}
COPY resin-xbuild /usr/bin/
RUN ln -s resin-xbuild /usr/bin/cross-build-start \
    && ln -s resin-xbuild /usr/bin/cross-build-end

# For backward compatibility, udev is enabled by default
ENV UDEV on

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
ENV TINI_VERSION #{TINI_VERSION}
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/#{TINI_BINARY}" \
    && echo "#{CHECKSUM}" | sha256sum -c - \
    && tar -xzf "#{TINI_BINARY}" \
    && rm "#{TINI_BINARY}" \
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
#{CGROUP}
ENTRYPOINT ["/usr/bin/entry.sh"]
