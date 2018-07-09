FROM resin/armv7hf-fedora:24
LABEL io.resin.device-type="bananapi-m1-plus"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all