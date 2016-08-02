FROM resin/armv7hf-fedora:23

LABEL io.resin.device-type="cubox-i"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all
