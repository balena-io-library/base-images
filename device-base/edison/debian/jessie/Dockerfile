FROM resin/i386-systemd:jessie

LABEL io.resin.device-type="edison"

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		module-init-tools \
		nano \
		net-tools \		
		i2c-tools \
		iputils-ping \		
		ifupdown \				
		usbutils \		
	&& rm -rf /var/lib/apt/lists/*

# MRAA
ENV MRAA_COMMIT a9429204e38416e04edbc1a6b5fe6ba49379493d
ENV MRAA_VERSION 0.10.1

# Install mraa
RUN set -x \
	&& buildDeps=' \
		build-essential \
		cmake \
		git-core \
		libpcre3-dev \
		python-dev \
		swig \
	' \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& git clone https://github.com/intel-iot-devkit/mraa.git \
	&& cd mraa \
	&& git checkout $MRAA_COMMIT \
	&& mkdir build && cd build \
	&& cmake .. -DBUILDSWIGNODE=OFF -DBUILDSWIGPYTHON=OFF \
	&& make -j $(nproc) \
	&& make install \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& cd / \
	&& rm -rf mraa


# Update Shared Library Cache
RUN echo "/usr/local/lib/i386-linux-gnu/" >> /etc/ld.so.conf \
	&& ldconfig
