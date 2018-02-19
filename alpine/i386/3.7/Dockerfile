FROM i386/alpine:3.7

LABEL io.resin.architecture="i386"

# For backward compatibility, udev is enabled by default
ENV UDEV on


COPY resin-xbuild /usr/bin/
RUN ln -s resin-xbuild /usr/bin/cross-build-start \
	&& ln -s resin-xbuild /usr/bin/cross-build-end

RUN apk add --update \
	bash \
	ca-certificates \
	dbus \
	findutils \
	openrc \
	tar \
	udev \
	tini \
	&& rm -rf /var/cache/apk/*

# Config OpenRC
RUN sed -i '/tty/d' /etc/inittab
COPY rc.conf /etc/

COPY resin /etc/init.d/

RUN rc-update add resin default \
	&& rc-update add dbus default

COPY entry.sh /usr/bin/entry.sh
                  
ENTRYPOINT ["/usr/bin/entry.sh"]
