FROM fedora:25

LABEL LABEL io.resin.architecture="amd64"


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
ENV TINI_VERSION 0.14.0
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/tini0.14.0.linux-amd64.tar.gz" \
    && echo "ed4f65aa016b7efded7948b21fd654718e7a1e4deb6521bf4ca39f956f985e4d tini0.14.0.linux-amd64.tar.gz" | sha256sum -c - \
    && tar -xzf "tini0.14.0.linux-amd64.tar.gz" \
    && rm "tini0.14.0.linux-amd64.tar.gz" \
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
