FROM resin/i386-nlp-alpine:3.7
LABEL io.resin.device-type="iot2000"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*