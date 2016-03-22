FROM resin/armv7hf-systemd:wheezy

LABEL io.resin.device-type="raspberrypi3"

RUN echo "deb http://archive.raspbian.org/raspbian wheezy main contrib non-free rpi firmware" >>  /etc/apt/sources.list
RUN apt-key adv --keyserver pgp.mit.edu  --recv-key 0x9165938D90FDDD2E

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		libraspberrypi-bin \
		module-init-tools \
		nano \
		net-tools \
		ifupdown \
		iputils-ping \
		i2c-tools \
		usbutils \		
	&& rm -rf /var/lib/apt/lists/*
