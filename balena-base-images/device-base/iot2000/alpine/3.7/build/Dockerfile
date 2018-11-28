FROM balenalib/i386-nlp-alpine:3.7-build
LABEL io.balena.device-type="iot2000"

RUN apk add --update \
		less \
		nano \
		net-tools \
		ifupdown \
		usbutils \
		gnupg \
	&& rm -rf /var/cache/apk/*

RUN [ ! -d /.balena ] && mkdir /.balena; echo 'Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: Intel 32-bit (x86) for Intel Quark \nOS: Alpine Linux 3.7 \nVariant: build variant \nDevice: Siemens IOT2000 \nDevice-type:iot2000 \nDefault variable(s): UDEV=off \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only)' > /.balena/image-info

ONBUILD RUN cat /.balena/image-info