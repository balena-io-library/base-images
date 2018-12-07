FROM arm32v6/alpine:3.8
LABEL io.balena.architecture="armv7hf"
 
LABEL io.balena.qemu.version="3.0.0+resin-arm"
COPY qemu-arm-static /usr/bin 

RUN apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  dbus \
  findutils \
  tar \
  udev \
  gnupg \
  && echo $'#!/bin/sh\n\
set -e\n\
set -u\n\
n=0\n\
max=2\n\
until [ $n -gt $max ]; do\n\
  set +e\n\
  (\n\
    apk add --no-cache "$@"\n\
  )\n\
  CODE=$?\n\
  set -e\n\
  if [ $CODE -eq 0 ]; then\n\
    break\n\
  fi\n\
  if [ $n -eq $max ]; then\n\
    exit $CODE\n\
  fi\n\
  echo "apk failed, retrying"\n\
  n=$(($n + 1))\n\
done' > /usr/sbin/install_packages \
  && chmod 0755 "/usr/sbin/install_packages"

# Install packages for build variant
RUN apk add --update \
		bzr \
		git \
		mercurial \
		openssh-client \
		subversion \
		ca-certificates \
		curl \
		wget \
		autoconf \
		build-base \
		imagemagick \
		libbz2 \
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

RUN curl -SLO "http://resin-packages.s3.amazonaws.com/resin-xbuild/v1.0.0/resin-xbuild1.0.0.tar.gz" \
  && echo "1eb099bc3176ed078aa93bd5852dbab9219738d16434c87fc9af499368423437  resin-xbuild1.0.0.tar.gz" | sha256sum -c - \
  && tar -xzf "resin-xbuild1.0.0.tar.gz" \
  && rm "resin-xbuild1.0.0.tar.gz" \
  && chmod +x resin-xbuild \
  && mv resin-xbuild /usr/bin \
  && ln -s resin-xbuild /usr/bin/cross-build-start \
  && ln -s resin-xbuild /usr/bin/cross-build-end

ENV UDEV off

COPY entry.sh /usr/bin/entry.sh
ENTRYPOINT ["/usr/bin/entry.sh"]