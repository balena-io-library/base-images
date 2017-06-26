FROM debian:wheezy

LABEL io.resin.architecture="amd64"

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive




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
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/tini0.14.0.linux-amd64.tar.gz" \
	&& echo "ed4f65aa016b7efded7948b21fd654718e7a1e4deb6521bf4ca39f956f985e4d  tini0.14.0.linux-amd64.tar.gz" | sha256sum -c - \
	&& tar -xzf "tini0.14.0.linux-amd64.tar.gz" \
	&& rm "tini0.14.0.linux-amd64.tar.gz" \
    && chmod +x tini \
    && mv tini /sbin/tini

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/
COPY 01_buildconfig /etc/apt/apt.conf.d/

RUN mkdir -p /usr/share/man/man1

ONBUILD RUN echo $'WARNING: Systemd is not available on this base image! \nSystemd was included in Debian wheezy as a technology preview. Therefore, we do not install systemd on wheezy images and INITSYSTEM will not work.'
ENTRYPOINT ["/usr/bin/entry.sh"]