FROM balenalib/amd64-fedora:30-build
LABEL io.balena.device-type="qemux86-64"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all