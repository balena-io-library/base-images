FROM balenalib/armv7hf-ubuntu:trusty-run
LABEL io.balena.device-type="imx7-var-som"

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