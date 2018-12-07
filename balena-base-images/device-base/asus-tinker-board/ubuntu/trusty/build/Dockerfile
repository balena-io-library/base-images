FROM balenalib/armv7hf-ubuntu:trusty-build
LABEL io.balena.device-type="asus-tinker-board"

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