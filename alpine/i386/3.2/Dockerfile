FROM i386/alpine:3.2

LABEL io.resin.architecture="i386"



RUN apk add --no-cache bash udev dbus tar ca-certificates

COPY entry.sh /usr/bin/entry.sh
                  
ENTRYPOINT ["/usr/bin/entry.sh"]
