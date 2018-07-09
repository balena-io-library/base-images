FROM resin/armv7hf-fedora:26
LABEL io.resin.device-type="via-vab820-quad"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all