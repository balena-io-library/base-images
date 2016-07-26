FROM #{FROM}

LABEL io.resin.device-type="#{DEV_TYPE}"
ONBUILD RUN BOLD_RED='\033[01;31m\033#6' \
	&& echo "${BOLD_RED}This base image is Debian armel. To make the best use of Raspberry PI hardware, you should use resin/rpi-raspbian base image instead!"

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		module-init-tools \
		nano \
		net-tools \
		ifupdown \
		iputils-ping \
		i2c-tools \
		usbutils \
	&& rm -rf /var/lib/apt/lists/*
