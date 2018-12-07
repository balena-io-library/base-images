FROM balenalib/armv7hf-alpine:3.8-run
LABEL io.balena.device-type="revpi-core-3"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
		raspberrypi \
		raspberrypi-libs \
		raspberrypi-dev \
	&& rm -rf /var/cache/apk/*