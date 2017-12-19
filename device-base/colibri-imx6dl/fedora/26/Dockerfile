FROM resin/armv7hf-fedora:26

LABEL io.resin.device-type="colibri-imx6dl"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		git-core \
		i2c-tools \
	&& dnf clean all
