FROM #{FROM}

LABEL io.resin.device-type="#{DEV_TYPE}"

RUN apk add --update \
		less \
		nano \
		net-tools \			
		ifupdown \				
		usbutils \
		git \
	&& rm -rf /var/cache/apk/*

# MRAA commit
ENV MRAA_COMMIT #{MRAA_COMMIT}

# Install mraa
RUN set -x \
	&& buildDeps=' \
		build-base \
		cmake \
		libpcrecpp \
		libpcre32 \
		python-dev \
		swig \
	' \
	&& apk add --update $buildDeps \
	&& git clone https://github.com/intel-iot-devkit/mraa.git \
	&& cd mraa \
	&& git checkout $MRAA_COMMIT \
	&& mkdir build && cd build \
	&& cmake .. -DBUILDSWIGNODE=OFF -DBUILDSWIGPYTHON=OFF \
	&& make -j $(nproc) \
	&& make install \
	&& apk del $buildDeps \
	&& cd / \
	&& rm -rf mraa \
	&& rm -rf /var/cache/apk/*


# Update Shared Library Cache
RUN echo "/usr/local/lib/i386-linux-gnu/" >> /etc/ld.so.conf \
	&& ldconfig
