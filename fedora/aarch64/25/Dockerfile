FROM arm64v8/fedora:25

LABEL io.resin.architecture="aarch64" io.resin.qemu.version="2.9.0.resin1-arm"

COPY qemu-aarch64-static /usr/bin/
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
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/tini0.14.0.linux-aarch64.tar.gz" \
	&& echo "5bfe3dcf7b41476c3ed99f886ac8a1ace2f72d4d5b04328de4a690b4dbec37b5  tini0.14.0.linux-aarch64.tar.gz" | sha256sum -c - \
	&& tar -xzf "tini0.14.0.linux-aarch64.tar.gz" \
	&& rm "tini0.14.0.linux-aarch64.tar.gz" \
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