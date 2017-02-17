FROM armhf/alpine:3.3

LABEL io.resin.architecture="armhf" io.resin.qemu.version="2.7.0-resin-rc3-arm"

COPY qemu-arm-static /usr/bin/qemu-arm-static

RUN apk add --update \
	bash \
	ca-certificates \
	dbus \
	findutils \
	openrc \
	tar \
	udev \
	&& rm -rf /var/cache/apk/*

# Config OpenRC
RUN sed -i '/tty/d' /etc/inittab
COPY rc.conf /etc/

COPY resin /etc/init.d/

RUN rc-update add resin default \
	&& rc-update add dbus default

COPY entry.sh /usr/bin/entry.sh
                  
ENTRYPOINT ["/usr/bin/entry.sh"]
