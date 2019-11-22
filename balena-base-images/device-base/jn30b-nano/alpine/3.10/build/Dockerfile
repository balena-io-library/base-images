FROM balenalib/aarch64-alpine:3.10-build
LABEL io.balena.device-type="jn30b-nano"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*