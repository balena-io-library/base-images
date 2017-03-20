FROM resin/amd64-alpine:3.4

LABEL io.resin.device-type="up-board"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*
