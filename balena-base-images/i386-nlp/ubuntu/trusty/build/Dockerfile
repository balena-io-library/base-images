FROM i386/ubuntu:trusty
LABEL io.balena.architecture="i386-nlp"

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
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && buildDeps='git-core autoconf libtool automake build-essential debhelper fakeroot cmake dpkg-dev devscripts' \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
  && git clone https://github.com/mdr78/libx1000.git \
  && cd libx1000 \
  && git checkout 1bfb62bb62e0ebe0e42817edd9702d91d232dbee \
  && cd libx1000-0.0.0 \
  && libtoolize --force \
  && aclocal \
  && autoheader \
  && automake --force-missing --add-missing \
  && autoconf \
  && ./autogen.sh \
  && ./configure \
  && make && make install \
  && apt-get purge -y --auto-remove $buildDeps \
  && cd / && rm -rf /libx1000

# Install packages for build variant
RUN apt-get update && apt-get install -y --no-install-recommends \
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
  && ln -s resin-xbuild /usr/bin/cross-build-start \
  && ln -s resin-xbuild /usr/bin/cross-build-end

ENV LC_ALL C.UTF-8
ENV UDEV off

RUN mkdir -p /usr/share/man/man1