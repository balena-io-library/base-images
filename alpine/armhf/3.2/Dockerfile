FROM armhf/alpine:3.2

LABEL io.resin.architecture="armhf" io.resin.qemu.version="2.5.0-resin-rc4"

COPY qemu-arm-static /usr/bin/qemu-arm-static

RUN apk add --no-cache bash udev dbus tar ca-certificates

COPY entry.sh /usr/bin/entry.sh
                  
ENTRYPOINT ["/usr/bin/entry.sh"]
