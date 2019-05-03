FROM arm32v7/fedora:26
LABEL io.balena.architecture="armv7hf"
 
LABEL io.balena.qemu.version="4.0.0+balena-arm"
COPY qemu-arm-static /usr/bin 

# Few tweaks for Fedora base image
RUN mkdir -p /etc/dnf/vars \
    && echo "armhfp" > /etc/dnf/vars/basearch \
    && echo "armv7hl" > /etc/dnf/vars/arch

RUN dnf update -y && dnf install -y \
  ca-certificates \
  findutils \
  hostname \
  tar \
  udev \
  which \
  curl \
  && dnf clean all \
  && echo $'#!/bin/sh\n\
set -e\n\
set -u\n\
n=0\n\
max=2\n\
until [ $n -gt $max ]; do\n\
  set +e\n\
  (\n\
    dnf update -y &&\n\
    dnf install -y "$@"\n\
  )\n\
  CODE=$?\n\
  set -e\n\
  if [ $CODE -eq 0 ]; then\n\
    break\n\
  fi\n\
  if [ $n -eq $max ]; then\n\
    exit $CODE\n\
  fi\n\
  echo "dnf failed, retrying"\n\
  n=$(($n + 1))\n\
done\n\
dnf clean all' > /usr/sbin/install_packages \
  && chmod 0755 "/usr/sbin/install_packages"

# Install packages for build variant
RUN dnf install -y \
		ca-certificates \
		curl \
		wget \
		bzr \
		git \
		mercurial \
		openssh-clients \
		subversion \
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