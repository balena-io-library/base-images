FROM balenalib/armv7hf-ubuntu:xenial-run
LABEL io.balena.device-type="fincm3"

RUN apt-get update && apt-get install -y --no-install-recommends \
		software-properties-common \
	&& add-apt-repository ppa:ubuntu-raspi2/ppa -y \
	&& apt-get purge -y --auto-remove software-properties-common \
	&& rm -rf /var/lib/apt/lists/*

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