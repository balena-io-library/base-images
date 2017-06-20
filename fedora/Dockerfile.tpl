FROM #{FROM}

LABEL #{LABEL}

#{QEMU}
COPY resin-xbuild /usr/bin/
RUN ln -s resin-xbuild /usr/bin/cross-build-start \
    && ln -s resin-xbuild /usr/bin/cross-build-end

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
ENV TINI_VERSION #{TINI_VERSION}
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/#{TINI_BINARY}" \
    && echo "#{CHECKSUM}" | sha256sum -c - \
    && tar -xzf "#{TINI_BINARY}" \
    && rm "#{TINI_BINARY}" \
    && chmod +x tini \
    && mv tini /sbin/tini

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
COPY launch.service /etc/systemd/system/launch.service

RUN systemctl enable launch.service systemd-udevd

STOPSIGNAL 37
VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT ["/usr/bin/entry.sh"]
