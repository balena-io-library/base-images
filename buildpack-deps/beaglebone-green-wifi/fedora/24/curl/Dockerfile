FROM resin/beaglebone-green-wifi-fedora:24

RUN dnf install -y \
		ca-certificates \
		curl \
		wget \
	&& dnf clean all
ONBUILD RUN echo 'This repository is deprecated. Please check https://docs.resin.io/runtime/resin-base-images/ for information about Resin docker images.' 
