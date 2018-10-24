FROM balenalib/armv7hf-ubuntu:xenial-build
LABEL io.balena.device-type="zc702-zynq7"

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		kmod \
		nano \
		net-tools \
		ifupdown \
		iputils-ping \
		i2c-tools \
		usbutils \
	&& rm -rf /var/lib/apt/lists/*