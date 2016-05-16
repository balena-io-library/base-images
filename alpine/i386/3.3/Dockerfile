FROM i386/alpine:3.3

LABEL io.resin.architecture="i386"



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
