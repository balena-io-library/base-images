FROM balenalib/armv7hf-alpine:3.7-run
LABEL io.balena.device-type="beagleboard-xm"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*