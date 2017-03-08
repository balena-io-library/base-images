FROM resin/beaglebone-green-wifi-python:3.3.6

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY requirements.txt /usr/src/app/
ONBUILD RUN pip install --no-cache-dir -r requirements.txt

ONBUILD COPY . /usr/src/app
ONBUILD RUN echo 'This repository is deprecated. Please check https://docs.resin.io/runtime/resin-base-images/ for information about Resin docker images.' 
