FROM resin/armhf-alpine:3.6

LABEL io.resin.device-type="am571x-evm"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
		git \
	&& rm -rf /var/cache/apk/*
