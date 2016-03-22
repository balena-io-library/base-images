FROM i386/alpine:3.3

LABEL io.resin.architecture="i386"



RUN apk add --update bash udev dbus tar ca-certificates \
	&& rm -rf /var/cache/apk/*

COPY entry.sh /usr/bin/entry.sh
                  
ENTRYPOINT ["/usr/bin/entry.sh"]
