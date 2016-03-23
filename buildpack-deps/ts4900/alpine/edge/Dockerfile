FROM resin/ts4900-alpine-buildpack-deps:edge-scm

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
	&& rm -rf /var/cache/apk/*
