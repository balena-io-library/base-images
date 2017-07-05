FROM #{FROM}

LABEL #{LABEL}

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

#{QEMU}
#{QEMU_CPU}

# Resin-xbuild
COPY resin-xbuild /usr/bin/
RUN ln -s resin-xbuild /usr/bin/cross-build-start \
	&& ln -s resin-xbuild /usr/bin/cross-build-end

RUN apt-get update && apt-get install -y --no-install-recommends \
		sudo \
		ca-certificates \
		findutils \
		gnupg \
		dirmngr \
		inetutils-ping \
		iproute \
		netbase \
		curl \
	&& rm -rf /var/lib/apt/lists/*

# Tini
ENV TINI_VERSION #{TINI_VERSION}
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v$TINI_VERSION/#{TINI_BINARY}" \
	&& echo "#{CHECKSUM}" | sha256sum -c - \
	&& tar -xzf "#{TINI_BINARY}" \
	&& rm "#{TINI_BINARY}" \
    && chmod +x tini \
    && mv tini /sbin/tini

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/
COPY 01_buildconfig /etc/apt/apt.conf.d/

RUN mkdir -p /usr/share/man/man1
