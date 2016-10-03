FROM resin/amd64-fedora:24

LABEL io.resin.device-type="nuc"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all
