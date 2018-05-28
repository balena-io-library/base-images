FROM i386/debian:buster-slim

LABEL io.resin.architecture="i386"

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
# For backward compatibility, udev is enabled by default
ENV UDEV on




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
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/tini0.14.0.linux-i386.tar.gz" \
	&& echo "9f4a0b536efdcbe92bc81c6e68dbf8dc1c5739e58f4e7e3a91f07094655149e8  tini0.14.0.linux-i386.tar.gz" | sha256sum -c - \
	&& tar -xzf "tini0.14.0.linux-i386.tar.gz" \
	&& rm "tini0.14.0.linux-i386.tar.gz" \
    && chmod +x tini \
    && mv tini /sbin/tini

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/
COPY 01_buildconfig /etc/apt/apt.conf.d/

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
COPY launch.service /etc/systemd/system/launch.service

RUN systemctl enable launch.service

STOPSIGNAL 37
ENTRYPOINT ["/usr/bin/entry.sh"]
