FROM balenalib/armv7hf-fedora:28-build
LABEL io.balena.device-type="odroid-c1"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all