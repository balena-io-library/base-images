FROM resin/armv7hf-alpine:edge
LABEL io.resin.device-type="beaglebone-green-wifi"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*