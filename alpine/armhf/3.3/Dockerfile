FROM armhf/alpine:3.3

LABEL io.resin.architecture="armhf" io.resin.qemu.version="2.5.0-resin-rc4"

COPY qemu-arm-static /usr/bin/qemu-arm-static

RUN apk add --update bash udev dbus tar ca-certificates \
	&& rm -rf /var/cache/apk/*

COPY entry.sh /usr/bin/entry.sh
                  
ENTRYPOINT ["/usr/bin/entry.sh"]
