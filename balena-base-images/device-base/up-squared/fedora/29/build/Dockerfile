FROM balenalib/amd64-fedora:29-build
LABEL io.balena.device-type="up-squared"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all