FROM balenalib/armv7hf-fedora:26-run
LABEL io.balena.device-type="raspberry-pi2"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all