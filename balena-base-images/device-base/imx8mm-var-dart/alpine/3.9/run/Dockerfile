FROM balenalib/aarch64-alpine:3.9-run
LABEL io.balena.device-type="imx8mm-var-dart"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*