---
dynamic:
  variables: [ $fedora_arch, $fedora_suite, $qemu, $tini ]
  ref: fedora/$fedora_arch/$fedora_suite/Dockerfile
  skip_ext: true
expand_props: [ $label, $type, $tiniVersion, $tiniChecksum ]
$label: '{{ getFedoraLabel }}'
$type: 'fedora'
$tiniChecksum: '{{ getTiniChecksumFedora }}'
---
FROM {{ $fedora_arch.base_image }}:{{ $fedora_suite.id }}

{{ $label }}

{{ include "install/qemu" }}
{{ include "install/resin-xbuild" }}
{{ include "install/fedora" }}

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
ENV TINI_VERSION {{ $tini.id }}
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/tini{{ $tini.id }}.linux-{{ $fedora_arch.id }}.tar.gz" \
	&& echo "{{ $tiniChecksum }}" | sha256sum -c - \
	&& tar -xzf "tini{{ $tini.id }}.linux-{{ $fedora_arch.id }}.tar.gz" \
	&& rm "tini{{ $tini.id }}.linux-{{ $fedora_arch.id }}.tar.gz" \
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