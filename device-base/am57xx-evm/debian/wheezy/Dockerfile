FROM resin/armv7hf-debian:wheezy

LABEL io.resin.device-type="am57xx-evm"

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		module-init-tools \
		nano \
		net-tools \
		ifupdown \	
		iputils-ping \	
		i2c-tools \
		usbutils \	
	&& rm -rf /var/lib/apt/lists/*
ONBUILD RUN echo 'This repository is deprecated. Please check https://docs.resin.io/runtime/resin-base-images/ for information about Resin docker images.' 
