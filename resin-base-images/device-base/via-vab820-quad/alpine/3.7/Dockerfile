FROM resin/armv7hf-alpine:3.7
LABEL io.resin.device-type="via-vab820-quad"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*