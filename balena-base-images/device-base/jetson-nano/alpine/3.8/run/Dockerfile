FROM balenalib/aarch64-alpine:3.8-run
LABEL io.balena.device-type="jetson-nano"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*