FROM balenalib/armv7hf-fedora:26-run
LABEL io.balena.device-type="imx6ul-var-dart"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all