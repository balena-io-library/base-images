FROM balenalib/aarch64-alpine:3.6-run
LABEL io.balena.device-type="artik710"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*