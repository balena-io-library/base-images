FROM #{FROM}

RUN apt-get update && apt-get install -y --no-install-recommends \
		python \
		python-dev \
		python-dbus \
		python-pip \
		python-virtualenv \
		python-setuptools \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i -e '2s@$@export PYTHONPATH="$(dirname $(find /usr/local -name mraa.py))"@' usr/bin/entry.sh

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/#/pages/using/dockerfile.md"]
