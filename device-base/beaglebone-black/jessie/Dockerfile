FROM resin/armv7hf-systemd:jessie

RUN echo "deb [arch=armhf] http://repos.rcn-ee.net/debian/ jessie main" >> /etc/apt/sources.list \
	&& echo "deb http://debian.beagleboard.org/packages  jessie-bbb main" >> /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key B2710B8359890110

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

RUN wget https://repos.rcn-ee.net/debian/pool/main/r/rcn-ee-archive-keyring/rcn-ee-archive-keyring_2015.05.06~bpo70+20150506+1_all.deb \
	&& dpkg -i rcn-ee-archive-keyring_2015.05.06~bpo70+20150506+1_all.deb \
	&& rm -f rcn-ee-archive-keyring_2015.05.06~bpo70+20150506+1_all.deb
