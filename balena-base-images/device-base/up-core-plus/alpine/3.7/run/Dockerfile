FROM balenalib/amd64-alpine:3.7-run
LABEL io.balena.device-type="up-core-plus"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo $'Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: Intel 64-bit (x86-64) \nOS: Alpine Linux 3.7 \nVariant: run variant \nDevice: UP Core Plus \nDevice-type:up-core-plus \nDefault variable(s): UDEV=off \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only)' > /.balena/messages/image-info

RUN echo $'#!/bin/bash\nbalena-info\nbusybox ln -sf /bin/busybox /bin/sh\n/bin/sh "$@"' > /bin/sh-shim \
	&& chmod +x /bin/sh-shim \
	&& ln -f /bin/sh /bin/sh.real \
	&& ln -f /bin/sh-shim /bin/sh