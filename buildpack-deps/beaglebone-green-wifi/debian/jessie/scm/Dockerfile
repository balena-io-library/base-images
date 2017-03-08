FROM resin/beaglebone-green-wifi-buildpack-deps:jessie-curl

RUN apt-get update && apt-get install -y --no-install-recommends \
		bzr \
		git \
		mercurial \
		openssh-client \
		subversion \
	&& rm -rf /var/lib/apt/lists/*
ONBUILD RUN echo 'This repository is deprecated. Please check https://docs.resin.io/runtime/resin-base-images/ for information about Resin docker images.' 
