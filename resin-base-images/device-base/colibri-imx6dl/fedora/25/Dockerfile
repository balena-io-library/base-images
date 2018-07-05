FROM resin/armv7hf-fedora:25
LABEL io.resin.device-type="colibri-imx6dl"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all