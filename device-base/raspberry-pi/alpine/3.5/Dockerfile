FROM resin/armhf-alpine:3.5

LABEL io.resin.device-type="raspberry-pi"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
		git \
		raspberrypi \
		raspberrypi-libs \
		raspberrypi-dev \
	&& rm -rf /var/cache/apk/*
