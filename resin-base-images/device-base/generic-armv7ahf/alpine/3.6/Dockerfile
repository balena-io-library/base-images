FROM resin/armv7hf-alpine:3.6
LABEL io.resin.device-type="generic-armv7ahf"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*