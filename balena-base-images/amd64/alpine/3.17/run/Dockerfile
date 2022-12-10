FROM alpine:3.17
LABEL io.balena.architecture="amd64"

RUN apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  dbus \
  findutils \
  tar \
  udev \
  gnupg \
  && echo $'#!/bin/sh\n\
set -e\n\
set -u\n\
n=0\n\
max=2\n\
until [ $n -gt $max ]; do\n\
  set +e\n\
  (\n\
    apk add --no-cache "$@"\n\
  )\n\
  CODE=$?\n\
  set -e\n\
  if [ $CODE -eq 0 ]; then\n\
    break\n\
  fi\n\
  if [ $n -eq $max ]; then\n\
    exit $CODE\n\
  fi\n\
  echo "apk failed, retrying"\n\
  n=$(($n + 1))\n\
done' > /usr/sbin/install_packages \
  && chmod 0755 "/usr/sbin/install_packages"

RUN curl -SLO "http://resin-packages.s3.amazonaws.com/resin-xbuild/v1.0.0/resin-xbuild1.0.0.tar.gz" \
  && echo "1eb099bc3176ed078aa93bd5852dbab9219738d16434c87fc9af499368423437  resin-xbuild1.0.0.tar.gz" | sha256sum -c - \
  && tar -xzf "resin-xbuild1.0.0.tar.gz" \
  && rm "resin-xbuild1.0.0.tar.gz" \
  && chmod +x resin-xbuild \
  && mv resin-xbuild /usr/bin \
  && ln -sf resin-xbuild /usr/bin/cross-build-start \
  && ln -sf resin-xbuild /usr/bin/cross-build-end

ENV UDEV off

COPY entry.sh /usr/bin/entry.sh
COPY balena-info /usr/bin/balena-info
COPY balena-idle /usr/bin/balena-idle
ENTRYPOINT ["/usr/bin/entry.sh"]

RUN curl -SLO "https://raw.githubusercontent.com/balena-io-library/base-images/a95300eda2320833e537ca20d728a870bf02177d/scripts/assets/tests/test-os.sh" \
  && echo "Running test-os" \
  && chmod +x test-os.sh \
  && bash test-os.sh alpine 3.17 \
  && rm -rf test-os.sh

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo $'Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: Intel 64-bit (x86-64) \nOS: Alpine Linux 3.17 \nVariant: run variant \nDefault variable(s): UDEV=off \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Keep the container idling with `balena-idle` command \n- Show base image details with `balena-info` command' > /.balena/messages/image-info