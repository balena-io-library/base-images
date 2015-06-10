FROM resin/raspberry-pi2-buildpack-deps:jessie

RUN apt-get update && apt-get install -y --no-install-recommends \
		python \
		python-dev \
		python-dbus \
		python-pip \
	&& rm -rf /var/lib/apt/lists/*

CMD ["python"]
