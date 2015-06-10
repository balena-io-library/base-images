FROM #{FROM}

RUN echo "deb http://archive.raspbian.org/raspbian jessie main contrib non-free rpi firmware" >>  /etc/apt/sources.list
RUN gpg --recv-keys --keyserver pgp.mit.edu 0x9165938D90FDDD2E \
	&& gpg -a --export 0x9165938D90FDDD2E | sudo apt-key add -

RUN apt-get update && apt-get install -y --no-install-recommends \
		usbutils \
		net-tools \
		iputils-ping \
		module-init-tools \
		ifupdown \
		less \
		i2c-tools \
		libraspberrypi-bin \
		nano \
	&& rm -rf /var/lib/apt/lists/*
