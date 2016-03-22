FROM #{FROM}

LABEL io.resin.device-type="#{DEV_TYPE}"

RUN apk add --update \
		less \
		nano \
		net-tools \			
		ifupdown \				
		usbutils \
	&& rm -rf /var/cache/apk/*

# MRAA v0.8.1 commit 
ENV MRAA_COMMIT 049ba5fa9f2d18ac0ec6729c46916b34998d3c5f

# Install mraa
RUN set -x \
	&& buildDeps=' \
		build-base \
		cmake \
		git \
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
