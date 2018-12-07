FROM balenalib/armv7hf-alpine:3.5-build
LABEL io.balena.device-type="asus-tinker-board-s"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*