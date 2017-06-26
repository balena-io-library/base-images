FROM armel/debian:sid

LABEL io.resin.architecture="armel" io.resin.qemu.version="2.9.0.resin1-arm"

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

COPY qemu-arm-static /usr/bin/
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
		iproute \
		netbase \
		curl \
	&& rm -rf /var/lib/apt/lists/*

# Tini
ENV TINI_VERSION 0.14.0
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/tini0.14.0.linux-armel.tar.gz" \
	&& echo "536054e9a0c665876b7d4e975bdbf866f1fd0b884acf490f10f2ab4fa0aed19d  tini0.14.0.linux-armel.tar.gz" | sha256sum -c - \
	&& tar -xzf "tini0.14.0.linux-armel.tar.gz" \
	&& rm "tini0.14.0.linux-armel.tar.gz" \
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