FROM resin/armhf-alpine:edge

LABEL io.resin.device-type="zc702-zynq7"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \		
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*
ONBUILD RUN echo 'This repository is deprecated. Please check https://docs.resin.io/runtime/resin-base-images/ for information about Resin docker images.' 
