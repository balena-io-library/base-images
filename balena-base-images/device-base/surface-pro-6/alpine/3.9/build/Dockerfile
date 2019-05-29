FROM balenalib/amd64-alpine:3.9-build
LABEL io.balena.device-type="surface-pro-6"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*