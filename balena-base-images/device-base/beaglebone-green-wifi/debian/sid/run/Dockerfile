FROM balenalib/armv7hf-debian:sid-run
LABEL io.balena.device-type="beaglebone-green-wifi"
RUN echo "deb [arch=armhf] http://repos.rcn-ee.net/debian/ sid main" >> /etc/apt/sources.list \
	&& apt-key adv --batch --keyserver keyserver.ubuntu.com --recv-key D284E608A4C46402

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		kmod \
		nano \
		net-tools \
		ifupdown \
		iputils-ping \
		i2c-tools \
		usbutils \
	&& rm -rf /var/lib/apt/lists/*

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo 'This base image is deprecated and will no longer receive updates. Refer to our blog post (https://blog.balena.io/deprecate-balenalib-images/) for migration guidance and suggested alternatives. \nHere are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: ARM v7 \nOS: Debian Sid \nVariant: run variant \nDefault variable(s): UDEV=off \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only) \n- Keep the container idling with `balena-idle` command \n- Show base image details with `balena-info` command' > /.balena/messages/image-info