FROM balenalib/aarch64-alpine:3.14-run
LABEL io.balena.device-type="rockpro64"

RUN apk add --update \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
	&& (apk add --no-cache ifupdown || apk add --no-cache ifupdown-ng) \
	&& rm -rf /var/cache/apk/*

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo $'Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: ARM v8 \nOS: Alpine Linux 3.14 \nVariant: run variant \nDefault variable(s): UDEV=off \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only) \n- Keep the container idling with `balena-idle` command \n- Show base image details with `balena-info` command' > /.balena/messages/image-info