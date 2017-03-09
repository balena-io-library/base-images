FROM resin/amd64-alpine:3.3

LABEL io.resin.device-type="intel-nuc"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*
