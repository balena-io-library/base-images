FROM #{FROM}

LABEL io.resin.device-type="#{DEV_TYPE}"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
		git \
	&& rm -rf /var/cache/apk/*
