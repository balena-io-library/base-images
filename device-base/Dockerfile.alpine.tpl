FROM #{FROM}

LABEL io.resin.device-type="#{DEV_TYPE}"

RUN apk add --no-cache \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg
