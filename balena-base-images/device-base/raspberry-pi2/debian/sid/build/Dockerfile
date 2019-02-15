FROM balenalib/armv7hf-debian:sid-build
LABEL io.balena.device-type="raspberry-pi2"
RUN echo "deb http://archive.raspbian.org/raspbian sid main contrib non-free rpi firmware" >>  /etc/apt/sources.list \
	&& apt-key adv --batch --keyserver ha.pool.sks-keyservers.net  --recv-key 0x9165938D90FDDD2E \
	&& echo "deb http://archive.raspberrypi.org/debian sid main ui" >>  /etc/apt/sources.list.d/raspi.list \
	&& apt-key adv --batch --keyserver ha.pool.sks-keyservers.net  --recv-key 0x82B129927FA3303E
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