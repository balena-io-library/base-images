FROM balenalib/i386-nlp-alpine:3.7-run
LABEL io.balena.device-type="cybertan-ze250"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*