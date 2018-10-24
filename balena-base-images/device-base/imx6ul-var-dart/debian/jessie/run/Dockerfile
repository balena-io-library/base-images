FROM balenalib/armv7hf-debian:jessie-run
LABEL io.balena.device-type="imx6ul-var-dart"

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		kmod \
		nano \
		net-tools \
		ifupdown \
		iputils-ping \
		i2c-tools \
		usbutils \
	&& rm -rf /var/lib/apt/lists/*