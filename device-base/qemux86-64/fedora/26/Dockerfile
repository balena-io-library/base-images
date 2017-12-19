FROM resin/amd64-fedora:26

LABEL io.resin.device-type="qemux86-64"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		git-core \
		i2c-tools \
	&& dnf clean all
