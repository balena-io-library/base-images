FROM resin/ts4900-fedora-buildpack-deps:23

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

RUN dnf install -y \
		python-pip \
		python-dbus \
	&& dnf clean all

# install "virtualenv", since the vast majority of users of this image will want it
RUN pip install -U --no-cache-dir --ignore-installed pip setuptools \
	&& pip install --no-cache-dir virtualenv

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http:/http://docs.resin.io/deployment/dockerfile"]
ONBUILD RUN echo 'This repository is deprecated. Please check https://docs.resin.io/runtime/resin-base-images/ for information about Resin docker images.' 
