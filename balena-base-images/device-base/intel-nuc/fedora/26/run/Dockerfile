FROM balenalib/amd64-fedora:26-run
LABEL io.balena.device-type="intel-nuc"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all