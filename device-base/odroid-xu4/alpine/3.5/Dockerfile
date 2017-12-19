FROM resin/armhf-alpine:3.5

LABEL io.resin.device-type="odroid-xu4"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
		git \
	&& rm -rf /var/cache/apk/*
