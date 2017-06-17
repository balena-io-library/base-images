FROM resin/armhf-alpine:3.6

LABEL io.resin.device-type="colibri-imx6dl"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*
