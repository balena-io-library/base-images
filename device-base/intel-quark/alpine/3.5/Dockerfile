FROM resin/i386-alpine:3.5

LABEL io.resin.device-type="intel-quark"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*
