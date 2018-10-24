FROM balenalib/armv7hf-ubuntu:artful-build
LABEL io.balena.device-type="bananapi-m1-plus"

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