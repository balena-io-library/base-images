FROM balenalib/aarch64-fedora:28-run
LABEL io.balena.device-type="srd3-tx2"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all