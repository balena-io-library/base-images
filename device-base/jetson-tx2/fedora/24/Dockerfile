FROM resin/aarch64-fedora:24

LABEL io.resin.device-type="jetson-tx2"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all
