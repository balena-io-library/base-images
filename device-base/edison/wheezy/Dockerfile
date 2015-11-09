FROM resin/i386-systemd:wheezy

RUN apt-get update && apt-get install -y --no-install-recommends \
		build-essential \
		ca-certificates \
		cmake \
		git-core \
		less \
		libpcre3-dev \
		module-init-tools \
		nano \
		net-tools \		
		i2c-tools \
		iputils-ping \		
		ifupdown \				
		python-dev \
		swig \
		usbutils \		
	&& rm -rf /var/lib/apt/lists/*

# Install mraa
RUN git clone https://github.com/intel-iot-devkit/mraa.git \
	&& mkdir mraa/build && cd mraa/build \
	&& cmake .. -DBUILDSWIGNODE=OFF \
	&& make -j $(nproc) \
	&& make install

# Update Shared Library Cache
RUN echo "/usr/local/lib/i386-linux-gnu/" >> /etc/ld.so.conf \
	&& ldconfig
