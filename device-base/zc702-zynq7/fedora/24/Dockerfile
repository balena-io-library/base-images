FROM resin/armv7hf-fedora:24

LABEL io.resin.device-type="zc702-zynq7"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		git-core \
		i2c-tools \
	&& dnf clean all
