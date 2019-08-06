FROM balenalib/amd64-fedora:31-build
LABEL io.balena.device-type="up-core"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all