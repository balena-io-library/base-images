FROM balenalib/armv7hf-alpine:3.9-run
LABEL io.balena.device-type="ts4900"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*