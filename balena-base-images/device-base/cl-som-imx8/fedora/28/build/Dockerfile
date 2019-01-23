FROM balenalib/aarch64-fedora:28-build
LABEL io.balena.device-type="cl-som-imx8"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all