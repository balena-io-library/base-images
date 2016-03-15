FROM #{FROM}

#{LABEL}

#{QEMU}

RUN apk add --no-cache bash udev dbus tar ca-certificates

COPY entry.sh /usr/bin/entry.sh
                  
ENTRYPOINT ["/usr/bin/entry.sh"]
