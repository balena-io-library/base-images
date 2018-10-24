FROM balenalib/armv7hf-fedora:27-build
LABEL io.balena.device-type="revpi-core-3"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all