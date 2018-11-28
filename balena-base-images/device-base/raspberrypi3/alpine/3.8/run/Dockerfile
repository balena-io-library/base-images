FROM balenalib/armv7hf-alpine:3.8-run
LABEL io.balena.device-type="raspberrypi3"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
		raspberrypi \
		raspberrypi-libs \
		raspberrypi-dev \
	&& rm -rf /var/cache/apk/*

RUN [ ! -d /.balena ] && mkdir /.balena; echo 'Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: ARM v7 \nOS: Alpine Linux 3.8 \nVariant: run variant \nDevice: Raspberry Pi 3 \nDevice-type:raspberrypi3 \nDefault variable(s): UDEV=off \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only)' > /.balena/image-info

ONBUILD RUN cat /.balena/image-info