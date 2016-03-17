FROM resin/armhf-alpine:edge

LABEL io.resin.device-type="ts7700"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*
