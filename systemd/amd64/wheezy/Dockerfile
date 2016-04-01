FROM resin/amd64-debian:wheezy

ONBUILD RUN echo $'WARNING: Systemd is not available on this base image! \nSystemd was included in Debian wheezy as a technology preview. Therefore, we do not install systemd on wheezy images and INITSYSTEM will not work.'

RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

COPY entry.sh /usr/bin/entry.sh

ENTRYPOINT ["/usr/bin/entry.sh"]
