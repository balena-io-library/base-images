FROM balenalib/armv7hf-alpine:3.7-build
LABEL io.balena.device-type="beaglebone-pocket"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*