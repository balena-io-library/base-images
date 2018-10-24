FROM balenalib/amd64-fedora:27-run
LABEL io.balena.device-type="up-board"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all