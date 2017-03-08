FROM resin/artik10-fedora-buildpack-deps:24-scm

RUN dnf install -y \
		autoconf \
		automake \
		bzip2-devel \
		glib2-devel \
		gcc \
		gcc-c++ \
		ImageMagick \
		ImageMagick-devel \
		kernel-devel \
		libcurl-devel \
		libevent-devel \
		libffi-devel \
		libjpeg-devel \
		libsqlite3x-devel \
		libxml2-devel \
		libxslt-devel \
		libyaml-devel \
		mysql-devel \
		make \
		ncurses-devel \
		openssl-devel \
		postgresql-devel \
		readline-devel \
		sqlite-devel \
		zlib-devel \
	&& dnf clean all
ONBUILD RUN echo 'This repository is deprecated. Please check https://docs.resin.io/runtime/resin-base-images/ for information about Resin docker images.' 
