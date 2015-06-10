FROM resin/i386-systemd:wheezy

RUN apt-get update && apt-get install -y --no-install-recommends \
		usbutils \
		net-tools \
		iputils-ping \
		module-init-tools \
		ifupdown \
		less \
		i2c-tools \
		nano \
		libpcre3-dev \		
		cmake \
		swig \
		python-dev \
		git-core \
		ca-certificates \
		build-essential \
	&& rm -rf /var/lib/apt/lists/*

# Install mraa
RUN git clone https://github.com/intel-iot-devkit/mraa.git \
	&& mkdir mraa/build && cd mraa/build \
	&& cmake .. -DBUILDSWIGNODE=OFF \
	&& make \
	&& make install \
	&& cd

# Update Shared Library Cache
RUN echo "/usr/local/lib/i386-linux-gnu/" >> /etc/ld.so.conf \
	&& ldconfig
