FROM balenalib/armv7hf-alpine:3.8-run
LABEL io.balena.device-type="nitrogen6x"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*