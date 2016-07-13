FROM debian:wheezy

LABEL io.resin.architecture="amd64"

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive



RUN apt-get update && apt-get install -y --no-install-recommends \
		sudo \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/
COPY 01_buildconfig /etc/apt/apt.conf.d/
ONBUILD RUN echo $'WARNING: Systemd is not available on this base image! \nSystemd was included in Debian wheezy as a technology preview. Therefore, we do not install systemd on wheezy images and INITSYSTEM will not work.'

COPY entry.sh /usr/bin/entry.sh

ENTRYPOINT ["/usr/bin/entry.sh"]
