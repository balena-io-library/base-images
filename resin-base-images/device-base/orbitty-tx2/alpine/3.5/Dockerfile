FROM resin/aarch64-alpine:3.5
LABEL io.resin.device-type="orbitty-tx2"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*