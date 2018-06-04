FROM debian:wheezy-slim
LABEL io.resin.architecture="amd64"

RUN apt-get update && apt-get install -y --no-install-recommends \
  sudo \
  ca-certificates \
  findutils \
  gnupg \
  dirmngr \
  inetutils-ping \
  netbase \
  curl \
  udev \
  $( \
      if apt-cache show 'iproute' 2>/dev/null | grep -q '^Version:'; then \
        echo 'iproute'; \
      else \
        echo 'iproute2'; \
      fi \
  ) \
  && rm -rf /var/lib/apt/lists/*

RUN curl -SLO "http://resin-packages.s3.amazonaws.com/resin-xbuild/v1.0.0/resin-xbuild1.0.0.tar.gz" \
  && echo "1eb099bc3176ed078aa93bd5852dbab9219738d16434c87fc9af499368423437  resin-xbuild1.0.0.tar.gz" | sha256sum -c - \
  && tar -xzf "resin-xbuild1.0.0.tar.gz" \
  && rm "resin-xbuild1.0.0.tar.gz" \
  && chmod +x resin-xbuild \
  && mv resin-xbuild /usr/bin \
  && ln -s resin-xbuild /usr/bin/cross-build-start \
  && ln -s resin-xbuild /usr/bin/cross-build-end

ENV TINI_VERSION 0.14.0
RUN curl -SLO "http://resin-packages.s3.amazonaws.com/tini/v0.14.0/tini0.14.0.linux-amd64.tar.gz" \
  && echo "a662ee1594cb037909237c87d577b6e4dee9879f1c23279f1a829683e542e4a0  tini0.14.0.linux-amd64.tar.gz" | sha256sum -c - \
  && tar -xzf "tini0.14.0.linux-amd64.tar.gz" \
  && rm "tini0.14.0.linux-amd64.tar.gz" \
  && chmod +x tini \
  && mv tini /sbin/tini

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
# For backward compatibility, udev is enabled by default
ENV UDEV on

# 01_nodoc
RUN echo 'path-exclude /usr/share/doc/*\n\
# we need to keep copyright files for legal reasons\n\
path-include /usr/share/doc/*/copyright\n\
path-exclude /usr/share/man/*\n\
path-exclude /usr/share/groff/*\n\
path-exclude /usr/share/info/*\n\
path-exclude /usr/share/lintian/*\n\
path-exclude /usr/share/linda/*\n\
path-exclude /usr/share/locale/*\n\
path-include /usr/share/locale/en*' > /etc/dpkg/dpkg.cfg.d/01_nodoc

# 01_buildconfig
RUN echo 'APT::Get::Assume-Yes "true";\n\
APT::Install-Recommends "0";\n\
APT::Install-Suggests "0";\n\
quiet "true";' > /etc/apt/apt.conf.d/01_buildconfig

RUN mkdir -p /usr/share/man/man1

ONBUILD RUN echo 'WARNING: Systemd is not available on this base image! \n\Systemd was included in Debian wheezy as a technology preview. Therefore, we do not install systemd on wheezy images and INITSYSTEM will not work.'

COPY entry.sh /usr/bin/entry.sh

ENTRYPOINT ["/usr/bin/entry.sh"]