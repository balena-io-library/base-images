FROM arm64v8/debian:jessie-slim

LABEL io.resin.architecture="aarch64" io.resin.qemu.version="2.9.0.resin1-aarch64"

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
# For backward compatibility, udev is enabled by default
ENV UDEV on

COPY qemu-aarch64-static /usr/bin/


# Resin-xbuild
COPY resin-xbuild /usr/bin/
RUN ln -s resin-xbuild /usr/bin/cross-build-start \
	&& ln -s resin-xbuild /usr/bin/cross-build-end

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

# Tini
ENV TINI_VERSION 0.14.0
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/tini0.14.0.linux-aarch64.tar.gz" \
	&& echo "edddd28f0c683773670592f6013f5eadb96bbf62a100f3d7d6c58e6a5cb248b4  tini0.14.0.linux-aarch64.tar.gz" | sha256sum -c - \
	&& tar -xzf "tini0.14.0.linux-aarch64.tar.gz" \
	&& rm "tini0.14.0.linux-aarch64.tar.gz" \
    && chmod +x tini \
    && mv tini /sbin/tini

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/
COPY 01_buildconfig /etc/apt/apt.conf.d/

RUN mkdir -p /usr/share/man/man1
# Install Systemd

RUN apt-get update && apt-get install -y --no-install-recommends \
		systemd \
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
    graphical.target

COPY entry.sh /usr/bin/entry.sh    
COPY launch.service /etc/systemd/system/launch.service

RUN systemctl enable /etc/systemd/system/launch.service

STOPSIGNAL 37
VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT ["/usr/bin/entry.sh"]
