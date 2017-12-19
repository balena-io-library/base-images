FROM resin/armhf-alpine:3.5

LABEL io.resin.device-type="kitra520"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
		git \
	&& rm -rf /var/cache/apk/*
