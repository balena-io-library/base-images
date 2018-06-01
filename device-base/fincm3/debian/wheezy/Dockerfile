FROM resin/armv7hf-debian:wheezy

LABEL io.resin.device-type="fincm3"

RUN #{SOURCES_LIST}

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		libraspberrypi-bin \
		kmod \
		nano \
		net-tools \
		ifupdown \
		iputils-ping \
		i2c-tools \
		usbutils \		
	&& rm -rf /var/lib/apt/lists/*
