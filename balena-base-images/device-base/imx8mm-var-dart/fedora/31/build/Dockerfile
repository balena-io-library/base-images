FROM balenalib/aarch64-fedora:31-build
LABEL io.balena.device-type="imx8mm-var-dart"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all