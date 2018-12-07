FROM balenalib/aarch64-alpine:3.6-build
LABEL io.balena.device-type="spacely-tx2"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*