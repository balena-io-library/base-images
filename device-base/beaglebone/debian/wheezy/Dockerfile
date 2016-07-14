FROM resin/armv7hf-debian:wheezy

LABEL io.resin.device-type="beaglebone"

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		module-init-tools \
		nano \
		net-tools \
		ifupdown \	
		iputils-ping \	
		i2c-tools \
		usbutils \
		wget \		
	&& rm -rf /var/lib/apt/lists/*

RUN echo "deb [arch=armhf] http://repos.rcn-ee.net/debian/ wheezy main" >> /etc/apt/sources.list && echo "deb http://debian.beagleboard.org/packages wheezy-bbb main" >> /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key D284E608A4C46402 && apt-key adv --keyserver keyserver.ubuntu.com --recv-key B2710B8359890110
