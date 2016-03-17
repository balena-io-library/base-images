FROM i386/alpine:edge

LABEL io.resin.architecture="i386"



RUN apk add --update bash udev dbus tar ca-certificates \
	&& rm -rf /var/cache/apk/*

COPY entry.sh /usr/bin/entry.sh
                  
ENTRYPOINT ["/usr/bin/entry.sh"]
