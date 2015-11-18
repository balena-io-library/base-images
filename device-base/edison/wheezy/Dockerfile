FROM resin/i386-systemd:wheezy

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

# MRAA v0.8.1 commit 
ENV MRAA_COMMIT 049ba5fa9f2d18ac0ec6729c46916b34998d3c5f

# Install mraa
RUN set -x \
	&& buildDeps=' \
		build-essential \
		ca-certificates \
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
