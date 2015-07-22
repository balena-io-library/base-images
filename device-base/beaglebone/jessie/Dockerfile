FROM resin/armv7hf-systemd:jessie

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

RUN echo "deb [arch=armhf] http://repos.rcn-ee.net/debian/ jessie main" >> /etc/apt/sources.list

RUN wget http://repos.rcn-ee.net/debian/pool/main/r/rcn-ee-archive-keyring/rcn-ee-archive-keyring_2015.07.05~bpo80+20150705+1_all.deb && dpkg -i rcn-ee-archive-keyring_2015.07.05~bpo80+20150705+1_all.deb && rm -f rcn-ee-archive-keyring_2015.07.05~bpo80+20150705+1_all.deb
