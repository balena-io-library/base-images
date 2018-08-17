FROM resin/armv7hf-debian:wheezy
LABEL io.resin.device-type="beaglebone-black"
RUN echo "deb http://debian.beagleboard.org/packages wheezy-bbb main" >> /etc/apt/sources.list \
	&& echo "deb [arch=armhf] http://repos.rcn-ee.net/debian/ wheezy main" >> /etc/apt/sources.list \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-key B2710B8359890110 \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-key D284E608A4C46402
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
