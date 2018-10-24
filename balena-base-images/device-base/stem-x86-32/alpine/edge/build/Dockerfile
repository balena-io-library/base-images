FROM balenalib/i386-alpine:edge-build
LABEL io.balena.device-type="stem-x86-32"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*