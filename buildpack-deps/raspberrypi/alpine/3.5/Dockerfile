FROM resin/raspberrypi-alpine-buildpack-deps:3.5-scm

RUN apk add --update \
		autoconf \
		build-base \
		imagemagick \
		libbz2 \
		#libcurl \
		libevent-dev \
		libffi-dev \
		glib-dev \
		jpeg-dev \
		imagemagick-dev \
		ncurses5-libs \
		libpq \
		readline-dev \
		sqlite-dev \
		openssl-dev \
		libxml2-dev \
		libxslt-dev \
		yaml-dev \
		zlib-dev \
		xz \
	&& rm -rf /var/cache/apk/*
ONBUILD RUN echo 'This repository is deprecated. Please check https://docs.resin.io/runtime/resin-base-images/ for information about Resin docker images.' 
