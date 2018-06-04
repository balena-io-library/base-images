FROM arm64v8/alpine:3.5
LABEL io.resin.architecture="aarch64"

 LABEL io.resin.qemu.version="2.9.0.resin1-aarch64"
COPY qemu-aarch64-static /usr/bin 

RUN apk add --update \
  bash \
  ca-certificates \
  curl \
  dbus \
  findutils \
  openrc \
  tar \
  udev \
  tini \
  && rm -rf /var/cache/apk/*

RUN curl -SLO "http://resin-packages.s3.amazonaws.com/resin-xbuild/v1.0.0/resin-xbuild1.0.0.tar.gz" \
  && echo "1eb099bc3176ed078aa93bd5852dbab9219738d16434c87fc9af499368423437  resin-xbuild1.0.0.tar.gz" | sha256sum -c - \
  && tar -xzf "resin-xbuild1.0.0.tar.gz" \
  && rm "resin-xbuild1.0.0.tar.gz" \
  && chmod +x resin-xbuild \
  && mv resin-xbuild /usr/bin \
  && ln -s resin-xbuild /usr/bin/cross-build-start \
  && ln -s resin-xbuild /usr/bin/cross-build-end

# For backward compatibility, udev is enabled by default
ENV UDEV on

# Config OpenRC
RUN sed -i '/tty/d' /etc/inittab

# rc.conf
RUN echo $'# Global OpenRC configuration settings\n\
# Ref: https://github.com/OpenRC/openrc/tree/master/etc\n\
rc_env_allow=*\n\
rc_crashed_stop=NO\n\
rc_crashed_start=YES\n\
rc_provide="loopback net"\n\
rc_sys="lxc"\n\
rc_tty_number=12' > /etc/rc.conf

# resin init script
RUN echo $'#!/sbin/openrc-run\n\
\n\
description="Resin.io User Application"\n\
pid_file=/var/run/resinapp.pid\n\
waiting_time=1000\n\
\n\
start() {\n\
	ebegin "Starting Resin.io User Application"\n\
	start-stop-daemon --start --exec /etc/resinApp.sh \\\n\
	--chdir #{DIR} \\\n\
	--make-pidfile --pidfile "$pid_file" --background \\\n\
	--stdout /dev/console \\\n\
	--stderr /dev/console \\\n\
	--wait "$waiting_time" \\\n\
	eend $?\n\
}\n\
\n\
stop() {\n\
	ebegin "Stopping Resin.io User Application"\n\
	start-stop-daemon --stop --exec /etc/resinApp.sh --pidfile $pid_file --wait "$waiting_time"\n\
	eend $?\n\
}' > /etc/init.d/resin

RUN chmod +x /etc/init.d/resin

RUN rc-update add resin default \
	&& rc-update add dbus default

COPY entry.sh /usr/bin/entry.sh

ENTRYPOINT ["/usr/bin/entry.sh"]