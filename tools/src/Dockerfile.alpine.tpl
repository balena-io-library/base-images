---
dynamic:
  variables: [ $alpine_arch, $alpine_suite, $qemu ]
  ref: alpine/$alpine_arch/$alpine_suite/Dockerfile
  skip_ext: true
expand_props: [ $label, $type ]
$label: '{{ getAlpineLabel }}'
$type: 'alpine'
---
FROM {{ $alpine_arch.base_image }}:{{ $alpine_suite.id }}

{{ $label }}

{{ include "install/qemu" }}
{{ include "install/resin-xbuild" }}

RUN apk add --update \
	bash \
	ca-certificates \
	dbus \
	findutils \
	openrc \
	tar \
	udev \
	tini \
	&& rm -rf /var/cache/apk/*

# Config OpenRC
RUN sed -i '/tty/d' /etc/inittab
COPY rc.conf /etc/

COPY resin /etc/init.d/

RUN rc-update add resin default \
	&& rc-update add dbus default

COPY entry.sh /usr/bin/entry.sh

ENTRYPOINT ["/usr/bin/entry.sh"]