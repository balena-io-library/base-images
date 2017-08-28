# Install Systemd

RUN echo 'deb http://deb.debian.org/debian jessie-backports main' >> /etc/apt/sources.list.d/jessie-backports.list \
	&& apt-get remove -y --allow-remove-essential systemd libsystemd0 udev libudev1 \
	&& apt autoremove -y \
	&& apt-get update \
	&& apt-get -t jessie-backports install -y --no-install-recommends \
		systemd \
		systemd-sysv udev \
	&& apt-mark hold systemd \
	&& rm -rf /etc/apt/sources.list.d/jessie-backports.list \
	&& rm -rf /var/lib/apt/lists/*

ENV container docker

# We only want few core services run in the container.
RUN find /etc/systemd/system \
		/lib/systemd/system \
		-path '*.wants/*' \
		-not -name '*journald*' \
		-not -name '*udevd*' \
		-not -name '*systemd-tmpfiles*' \
		-not -name '*systemd-user-sessions*' \
		-exec rm \{} \;

COPY entry.sh /usr/bin/entry.sh
COPY launch.service /etc/systemd/system/launch.service

RUN systemctl enable /etc/systemd/system/launch.service

STOPSIGNAL 37
ENTRYPOINT ["/usr/bin/entry.sh"]
