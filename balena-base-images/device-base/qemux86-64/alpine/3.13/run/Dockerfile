FROM balenalib/amd64-alpine:3.13-run
LABEL io.balena.device-type="qemux86-64"

RUN apk add --update \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
	&& (apk add --no-cache ifupdown || apk add --no-cache ifupdown-ng) \
	&& rm -rf /var/cache/apk/*

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo $'This base image is deprecated and will no longer receive updates. Refer to our blog post (https://blog.balena.io/deprecate-balenalib-images/) for migration guidance and suggested alternatives. \nHere are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: Intel 64-bit (x86-64) \nOS: Alpine Linux 3.13 \nVariant: run variant \nDefault variable(s): UDEV=off \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only) \n- Keep the container idling with `balena-idle` command \n- Show base image details with `balena-info` command' > /.balena/messages/image-info