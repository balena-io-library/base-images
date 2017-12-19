FROM #{FROM}

LABEL io.resin.device-type="#{DEV_TYPE}"

RUN #{SOURCES_LIST}

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		libraspberrypi-bin \
		kmod \
		nano \
		net-tools \
		git \
		ifupdown \
		iputils-ping \
		i2c-tools \
		usbutils \		
	&& rm -rf /var/lib/apt/lists/*
