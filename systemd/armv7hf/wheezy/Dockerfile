FROM resin/armv7hf-debian:wheezy

RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

COPY entry.sh /usr/bin/entry.sh

ENTRYPOINT ["/usr/bin/entry.sh"]
