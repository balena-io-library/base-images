FROM balenalib/armv7hf-alpine:3.8-run
LABEL io.balena.device-type="orangepi-plus2"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*