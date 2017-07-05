FROM arm32v7/debian:wheezy-slim

LABEL io.resin.architecture="armv7hf" io.resin.qemu.version="2.9.0.resin1-arm"

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

COPY qemu-arm-static /usr/bin/


# Resin-xbuild
COPY resin-xbuild /usr/bin/
RUN ln -s resin-xbuild /usr/bin/cross-build-start \
	&& ln -s resin-xbuild /usr/bin/cross-build-end

RUN apt-get update && apt-get install -y --no-install-recommends \
		sudo \
		ca-certificates \
		findutils \
		gnupg \
		dirmngr \
		inetutils-ping \
		iproute \
		netbase \
		curl \
	&& rm -rf /var/lib/apt/lists/*

# Tini
ENV TINI_VERSION 0.14.0
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/tini0.14.0.linux-armv7hf.tar.gz" \
	&& echo "cab86b2ad88ae6a3ef649293a5fecbc55bc31722cc8220f7b82bd6c960553e44 tini0.14.0.linux-armv7hf.tar.gz" | sha256sum -c - \
	&& tar -xzf "tini0.14.0.linux-armv7hf.tar.gz" \
	&& rm "tini0.14.0.linux-armv7hf.tar.gz" \
    && chmod +x tini \
    && mv tini /sbin/tini

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/
COPY 01_buildconfig /etc/apt/apt.conf.d/

RUN mkdir -p /usr/share/man/man1
ONBUILD RUN echo $'WARNING: Systemd is not available on this base image! \nSystemd was included in Debian wheezy as a technology preview. Therefore, we do not install systemd on wheezy images and INITSYSTEM will not work.'

COPY entry.sh /usr/bin/entry.sh

ENTRYPOINT ["/usr/bin/entry.sh"]
