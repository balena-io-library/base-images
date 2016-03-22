FROM alpine:edge

LABEL io.resin.architecture="amd64"



RUN apk add --update bash udev dbus tar ca-certificates \
	&& rm -rf /var/cache/apk/*

COPY entry.sh /usr/bin/entry.sh
                  
ENTRYPOINT ["/usr/bin/entry.sh"]
