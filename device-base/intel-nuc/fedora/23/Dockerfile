FROM resin/amd64-fedora:23

LABEL io.resin.device-type="intel-nuc"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all
