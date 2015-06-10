FROM resin/intel-edison-buildpack-deps:wheezy

RUN apt-get update && apt-get install -y --no-install-recommends \
		python \
		python-dev \
		python-dbus \
		python-pip \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i -e '2s@$@export PYTHONPATH="$(dirname $(find /usr/local -name mraa.py))"@' usr/bin/entry.sh

CMD ["python"]
