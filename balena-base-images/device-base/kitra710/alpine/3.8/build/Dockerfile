FROM balenalib/aarch64-alpine:3.8-build
LABEL io.balena.device-type="kitra710"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*