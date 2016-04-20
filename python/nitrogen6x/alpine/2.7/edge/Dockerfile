FROM resin/nitrogen6x-alpine-buildpack-deps:edge

# remove several traces of python
RUN apk del python*

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# install dbus-python dependencies 
RUN apk add --no-cache \
		dbus-dev \
		dbus-glib-dev

# key 63C7CC90: public key "Simon McVittie <smcv@pseudorandom.co.uk>" imported
RUN gpg --keyserver keyring.debian.org --recv-keys 4DE8FF2A63C7CC90

# key 3372DCFA: public key "Donald Stufft (dstufft) <donald@stufft.io>" imported
RUN gpg --keyserver pgp.mit.edu  --recv-key 6E3CBCE93372DCFA

ENV PYTHON_VERSION 2.7.11

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 8.1.1

ENV SETUPTOOLS_SHA256 24fcfc15364a9fe09a220f37d2dcedc849795e3de3e4b393ee988e66a9cbd85a
ENV SETUPTOOLS_VERSION 20.2.2

# point Python at a system-provided certificate database. Otherwise, we might hit CERTIFICATE_VERIFY_FAILED.
# https://www.python.org/dev/peps/pep-0476/#trust-database
ENV SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt

RUN set -x \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/python/v$PYTHON_VERSION/Python-$PYTHON_VERSION.linux-alpine-armhf.tar.gz" \
	&& echo "e447748b5802d5e5ba4b826218a15aa0058b523875546b1037fd5a54d5f550ae  Python-2.7.11.linux-alpine-armhf.tar.gz" | sha256sum -c - \
	&& tar -xzf "Python-$PYTHON_VERSION.linux-alpine-armhf.tar.gz" --strip-components=1 \
	&& rm -rf "Python-$PYTHON_VERSION.linux-alpine-armhf.tar.gz" \
	&& mkdir -p /usr/src/python/setuptools \
	&& curl -SLO https://pypi.python.org/packages/source/s/setuptools/setuptools-$SETUPTOOLS_VERSION.tar.gz \
	&& echo "$SETUPTOOLS_SHA256  setuptools-$SETUPTOOLS_VERSION.tar.gz" > setuptools-$SETUPTOOLS_VERSION.tar.gz.sha256sum \
	&& sha256sum -c setuptools-$SETUPTOOLS_VERSION.tar.gz.sha256sum \
	&& tar -xzC /usr/src/python/setuptools --strip-components=1 -f setuptools-$SETUPTOOLS_VERSION.tar.gz \
	&& rm -rf setuptools-$SETUPTOOLS_VERSION.tar.gz* \
	&& cd /usr/src/python/setuptools \
	&& python2 ez_setup.py \
	&& mkdir -p /usr/src/python/pip \
	&& curl -SL "https://pypi.python.org/packages/source/p/pip/pip-$PYTHON_PIP_VERSION.tar.gz" -o pip.tar.gz \
	&& curl -SL "https://pypi.python.org/packages/source/p/pip/pip-$PYTHON_PIP_VERSION.tar.gz.asc" -o pip.tar.gz.asc \
	&& gpg --verify pip.tar.gz.asc \
	&& tar -xzC /usr/src/python/pip --strip-components=1 -f pip.tar.gz \
	&& rm pip.tar.gz* \
	&& cd /usr/src/python/pip \
	&& python2 setup.py install \
	&& cd .. \
	&& find /usr/local \
		\( -type d -a -name test -o -name tests \) \
		-o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		-exec rm -rf '{}' + \
	&& cd / \
	&& rm -rf /usr/src/python ~/.cache

# install "virtualenv", since the vast majority of users of this image will want it
RUN pip install --no-cache-dir virtualenv

ENV PYTHON_DBUS_VERSION 1.2.0

# install dbus-python
RUN set -x \
	&& mkdir -p /usr/src/dbus-python \
	&& curl -SL "http://dbus.freedesktop.org/releases/dbus-python/dbus-python-$PYTHON_DBUS_VERSION.tar.gz" -o dbus-python.tar.gz \
	&& curl -SL "http://dbus.freedesktop.org/releases/dbus-python/dbus-python-$PYTHON_DBUS_VERSION.tar.gz.asc" -o dbus-python.tar.gz.asc \
	&& gpg --verify dbus-python.tar.gz.asc \
	&& tar -xzC /usr/src/dbus-python --strip-components=1 -f dbus-python.tar.gz \
	&& rm dbus-python.tar.gz* \
	&& cd /usr/src/dbus-python \
	&& PYTHON=python2.7 ./configure \
	&& make \
	&& make install \
	&& cd / \
	&& rm -rf /usr/src/dbus-python

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/#/pages/using/dockerfile.md"]
ENV PYTHONPATH /usr/lib/python2.7/dist-packages
