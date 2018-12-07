FROM balenalib/i386-nlp-alpine:3.5-build
LABEL io.balena.device-type="iot2000"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*