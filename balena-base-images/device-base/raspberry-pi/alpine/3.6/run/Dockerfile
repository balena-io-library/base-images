FROM balenalib/rpi-alpine:3.6-run
LABEL io.balena.device-type="raspberry-pi"

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