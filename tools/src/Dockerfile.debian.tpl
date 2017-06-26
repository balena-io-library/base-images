---
dynamic:
  variables: [ $debian_arch, $debian_suite, $qemu, $tini ]
  ref: debian/$debian_arch/$debian_suite/Dockerfile
  skip_ext: true
expand_props: [ $label, $isUnsupported, $type, $tiniVersion, $tiniChecksum ]
$isUnsupported: '{{ getDebianStatus }}'
$label: '{{ getDebianLabel }}'
$type: 'debian'
$tiniChecksum: '{{ getTiniChecksumDebian }}'
---
FROM {{ $debian_arch.base_image }}:{{ $debian_suite.id }}

{{ $label }}

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

{{ include "install/qemu" }}
{{ include "install/resin-xbuild" }}

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
ENV TINI_VERSION {{ $tini.id }}
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/tini{{ $tini.id }}.linux-{{ $debian_arch.id }}.tar.gz" \
	&& echo "{{ $tiniChecksum }}" | sha256sum -c - \
	&& tar -xzf "tini{{ $tini.id }}.linux-{{ $debian_arch.id }}.tar.gz" \
	&& rm "tini{{ $tini.id }}.linux-{{ $debian_arch.id }}.tar.gz" \
    && chmod +x tini \
    && mv tini /sbin/tini

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/
COPY 01_buildconfig /etc/apt/apt.conf.d/

RUN mkdir -p /usr/share/man/man1

{{ include "install/debian" }}
ENTRYPOINT ["/usr/bin/entry.sh"]