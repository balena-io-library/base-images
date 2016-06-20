FROM armhf/alpine:3.4

LABEL io.resin.architecture="armhf" io.resin.qemu.version="2.5.0-resin-rc3"

COPY qemu-arm-static /usr/bin/qemu-arm-static

RUN apk add --update bash udev dbus tar ca-certificates openrc \
	&& rm -rf /var/cache/apk/*

# Config OpenRC
RUN sed -i '/tty/d' /etc/inittab
COPY rc.conf /etc/

COPY resin /etc/init.d/

RUN rc-update add resin default \
	&& rc-update add dbus default

COPY entry.sh /usr/bin/entry.sh
                  
ENTRYPOINT ["/usr/bin/entry.sh"]
