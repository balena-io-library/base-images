FROM resin/armhf-alpine:3.5

LABEL io.resin.device-type="colibri-imx6dl"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
		git \
	&& rm -rf /var/cache/apk/*
