FROM resin/aarch64-fedora:25
LABEL io.resin.device-type="orbitty-tx2"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all