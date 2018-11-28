FROM balenalib/i386-alpine:3.5-build
LABEL io.balena.device-type="stem-x86-32"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*

RUN [ ! -d /.balena ] && mkdir /.balena; echo 'Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: Intel 32-bit (x86) \nOS: Alpine Linux 3.5 \nVariant: build variant \nDevice: Stem x86 32bit \nDevice-type:stem-x86-32 \nDefault variable(s): UDEV=off \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only)' > /.balena/image-info

ONBUILD RUN cat /.balena/image-info