FROM arm32v7/fedora:25

LABEL io.resin.architecture="armv7hf" io.resin.qemu.version="2.9.0.resin1-arm"

COPY qemu-arm-static /usr/bin/
COPY resin-xbuild /usr/bin/
RUN ln -s resin-xbuild /usr/bin/cross-build-start \
	&& ln -s resin-xbuild /usr/bin/cross-build-end
RUN mkdir -p /etc/dnf/vars \
	&& echo "armhfp" > /etc/dnf/vars/basearch \
	&& echo "armv7hl" > /etc/dnf/vars/arch

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
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/tini0.14.0.linux-armv7hf.tar.gz" \
	&& echo "5926f7d9e4442025bbf8f277bde1accc183be4952c3e3f601aece3fdbcdcd9df  tini0.14.0.linux-armv7hf.tar.gz" | sha256sum -c - \
	&& tar -xzf "tini0.14.0.linux-armv7hf.tar.gz" \
	&& rm "tini0.14.0.linux-armv7hf.tar.gz" \
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