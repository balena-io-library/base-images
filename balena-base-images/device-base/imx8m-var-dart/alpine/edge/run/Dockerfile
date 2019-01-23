FROM balenalib/aarch64-alpine:edge-run
LABEL io.balena.device-type="imx8m-var-dart"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*