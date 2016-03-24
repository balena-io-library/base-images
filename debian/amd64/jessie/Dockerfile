FROM debian:jessie

LABEL io.resin.architecture="amd64"

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive



RUN apt-get update && apt-get install -y --no-install-recommends \
		sudo \
	&& rm -rf /var/lib/apt/lists/*

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/
COPY 01_buildconfig /etc/apt/apt.conf.d/
