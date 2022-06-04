FROM ubuntu:focal
LABEL io.balena.architecture="amd64"

RUN apt-get update && apt-get install -y --no-install-recommends \
  sudo \
  ca-certificates \
  findutils \
  gnupg \
  dirmngr \
  inetutils-ping \
  netbase \
  curl \
  udev \
  $( \
      if apt-cache show 'iproute' 2>/dev/null | grep -q '^Version:'; then \
        echo 'iproute'; \
      else \
        echo 'iproute2'; \
      fi \
  ) \
  && rm -rf /var/lib/apt/lists/* \
  && c_rehash \
  && echo '#!/bin/sh\n\
set -e\n\
set -u\n\
export DEBIAN_FRONTEND=noninteractive\n\
n=0\n\
max=2\n\
until [ $n -gt $max ]; do\n\
  set +e\n\
  (\n\
    apt-get update -qq &&\n\
    apt-get install -y --no-install-recommends "$@"\n\
  )\n\
  CODE=$?\n\
  set -e\n\
  if [ $CODE -eq 0 ]; then\n\
    break\n\
  fi\n\
  if [ $n -eq $max ]; then\n\
    exit $CODE\n\
  fi\n\
  echo "apt failed, retrying"\n\
  n=$(($n + 1))\n\
done\n\
rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*' > /usr/sbin/install_packages \
  && chmod 0755 "/usr/sbin/install_packages"

# Install packages for build variant
RUN install_packages \
		ca-certificates \
		curl \
		wget \
		bzr \
		git \
		mercurial \
		openssh-client \
		subversion \
		autoconf \
		build-essential \
		imagemagick \
		libbz2-dev \
		libcurl4-openssl-dev \
		libevent-dev \
		libffi-dev \
		libglib2.0-dev \
		libjpeg-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libncurses-dev \
		libpq-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libxml2-dev \
		libxslt-dev \
		libyaml-dev \
		zlib1g-dev \
		$( \
			if apt-cache show 'default-libmysqlclient-dev' 2>/dev/null | grep -q '^Version:'; then \
				echo 'default-libmysqlclient-dev'; \
			else \
				echo 'libmysqlclient-dev'; \
			fi \
		) \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -SLO "http://resin-packages.s3.amazonaws.com/resin-xbuild/v1.0.0/resin-xbuild1.0.0.tar.gz" \
  && echo "1eb099bc3176ed078aa93bd5852dbab9219738d16434c87fc9af499368423437  resin-xbuild1.0.0.tar.gz" | sha256sum -c - \
  && tar -xzf "resin-xbuild1.0.0.tar.gz" \
  && rm "resin-xbuild1.0.0.tar.gz" \
  && chmod +x resin-xbuild \
  && mv resin-xbuild /usr/bin \
  && ln -sf resin-xbuild /usr/bin/cross-build-start \
  && ln -sf resin-xbuild /usr/bin/cross-build-end

ENV LC_ALL C.UTF-8
ENV UDEV off

RUN mkdir -p /usr/share/man/man1

COPY entry.sh /usr/bin/entry.sh
COPY balena-info /usr/bin/balena-info
COPY balena-idle /usr/bin/balena-idle
ENTRYPOINT ["/usr/bin/entry.sh"]

RUN curl -SLO "https://raw.githubusercontent.com/balena-io-library/base-images/a95300eda2320833e537ca20d728a870bf02177d/scripts/assets/tests/test-os.sh" \
  && echo "Running test-os" \
  && chmod +x test-os.sh \
  && bash test-os.sh ubuntu focal \
  && rm -rf test-os.sh

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo 'Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: Intel 64-bit (x86-64) \nOS: Ubuntu focal \nVariant: build variant \nDefault variable(s): UDEV=off \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Keep the container idling with `balena-idle` command \n- Show base image details with `balena-info` command' > /.balena/messages/image-info