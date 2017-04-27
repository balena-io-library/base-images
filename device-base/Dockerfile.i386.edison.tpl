FROM #{FROM}

LABEL io.resin.device-type="#{DEV_TYPE}"

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		kmod \
		nano \
		net-tools \		
		i2c-tools \
		iputils-ping \		
		ifupdown \				
		usbutils \		
	&& rm -rf /var/lib/apt/lists/*

# MRAA
ENV MRAA_COMMIT #{MRAA_COMMIT}
ENV MRAA_VERSION #{MRAA_VERSION}
# UPM
ENV UPM_COMMIT #{UPM_COMMIT}
ENV UPM_VERSION #{UPM_VERSION}

# Install mraa
RUN set -x \
	&& buildDeps=' \
		build-essential \
		git-core \
		libpcre3-dev \
		python-dev \
		swig \
		pkg-config \
		curl \
	' \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& mkdir /cmake \ 
	&& curl -SL https://cmake.org/files/v3.5/cmake-3.5.2.tar.gz -o cmake.tar.gz \
	&& echo "92d8410d3d981bb881dfff2aed466da55a58d34c7390d50449aa59b32bb5e62a  cmake.tar.gz" | sha256sum -c - \
	&& tar -xzf cmake.tar.gz -C /cmake --strip-components=1 \
	&& cd /cmake \
	&& ./configure \
	&& make -j $(nproc) \
	&& make install \
	&& cd / \
	&& git clone https://github.com/intel-iot-devkit/mraa.git \
	&& cd /mraa \
	&& git checkout $MRAA_COMMIT \
	&& mkdir build && cd build \
	&& cmake .. -DBUILDSWIGNODE=OFF -DBUILDSWIGPYTHON=OFF -DCMAKE_INSTALL_PREFIX:PATH=/usr \
	&& make -j $(nproc) \
	&& make install \
	&& cd / \
	&& git clone https://github.com/intel-iot-devkit/upm.git \
	&& cd /upm \
	&& git checkout $UPM_COMMIT \
	&& mkdir build && cd build \
	&& cmake .. -DBUILDSWIGNODE=OFF -DBUILDSWIGPYTHON=OFF -DCMAKE_INSTALL_PREFIX:PATH=/usr \
	&& make -j $(nproc) \
	&& make install \
	&& cd /cmake \
	&& make uninstall \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& cd / && rm -rf mraa upm cmake


# Update Shared Library Cache
RUN echo "/usr/local/lib/i386-linux-gnu/" >> /etc/ld.so.conf \
	&& ldconfig
