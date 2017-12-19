FROM resin/armv7hf-fedora:25

LABEL io.resin.device-type="artik5"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		git-core \
		i2c-tools \
	&& dnf clean all
