FROM balenalib/i386-alpine:edge-run
LABEL io.balena.device-type="intel-edison"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*