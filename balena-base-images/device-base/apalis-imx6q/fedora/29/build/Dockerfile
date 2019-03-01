FROM balenalib/armv7hf-fedora:29-build
LABEL io.balena.device-type="apalis-imx6q"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all