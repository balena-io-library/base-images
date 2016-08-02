FROM #{FROM}

LABEL io.resin.device-type="#{DEV_TYPE}"

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
	&& dnf clean all
