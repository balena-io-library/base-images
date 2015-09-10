FROM resin/odroid-ux3-buildpack-deps:wheezy

RUN apt-get update && apt-get install -y --no-install-recommends \
		python \
		python-dev \
		python-dbus \
		python-pip \
	&& rm -rf /var/lib/apt/lists/*

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/#/pages/using/dockerfile.md"]
