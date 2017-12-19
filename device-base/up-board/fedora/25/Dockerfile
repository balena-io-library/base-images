FROM resin/amd64-fedora:25

LABEL io.resin.device-type="up-board"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		git-core \
		i2c-tools \
	&& dnf clean all
