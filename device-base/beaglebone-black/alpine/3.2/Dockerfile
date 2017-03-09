FROM resin/armhf-alpine:3.2

LABEL io.resin.device-type="beaglebone-black"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*
