FROM resin/i386-alpine:3.6

LABEL io.resin.device-type="cybertan-ze250"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*
