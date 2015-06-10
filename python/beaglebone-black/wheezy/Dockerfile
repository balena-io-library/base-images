FROM resin/beaglebone-black-buildpack-deps:wheezy

RUN apt-get update && apt-get install -y --no-install-recommends \
		python \
		python-dev \
		python-dbus \
		python-pip \
	&& rm -rf /var/lib/apt/lists/*

CMD ["python"]
