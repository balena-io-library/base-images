FROM resin/armv7hf-debian:buster

LABEL io.resin.device-type="raspberry-pi2"

RUN echo "deb http://archive.raspbian.org/raspbian buster main contrib non-free rpi firmware" >>  /etc/apt/sources.list \
	&& apt-key adv --keyserver pgp.mit.edu  --recv-key 0x9165938D90FDDD2E

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		libraspberrypi-bin \
		kmod \
		nano \
		net-tools \
		git \
		ifupdown \
		iputils-ping \
		i2c-tools \
		usbutils \		
	&& rm -rf /var/lib/apt/lists/*
