FROM balenalib/amd64-alpine:edge-build
LABEL io.balena.device-type="surface-go"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*