FROM balenalib/armv7hf-debian:buster-run
LABEL io.balena.device-type="revpi-core-3"
RUN echo "deb http://archive.raspbian.org/raspbian buster main contrib non-free rpi firmware" >>  /etc/apt/sources.list \
	&& apt-key adv --batch --keyserver pgp.mit.edu  --recv-key 0x9165938D90FDDD2E
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