FROM resin/i386-alpine:3.6

LABEL io.resin.device-type="iot2000"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
		git \
	&& rm -rf /var/cache/apk/*
