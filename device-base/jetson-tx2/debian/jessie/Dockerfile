FROM resin/aarch64-debian:jessie

LABEL io.resin.device-type="jetson-tx2"

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		kmod \
		nano \
		net-tools \
		ifupdown \	
		iputils-ping \	
		i2c-tools \
		git \
		usbutils \	
	&& rm -rf /var/lib/apt/lists/*
