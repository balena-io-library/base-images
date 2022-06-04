FROM balenalib/armv7hf-debian:buster-build
LABEL io.balena.device-type="raspberry-pi2"
RUN echo "deb http://archive.raspbian.org/raspbian buster main contrib non-free rpi firmware" >>  /etc/apt/sources.list \
	&& apt-key adv --batch --keyserver keyserver.ubuntu.com  --recv-key 0x9165938D90FDDD2E \
	&& echo "deb http://archive.raspberrypi.org/debian buster main ui" >>  /etc/apt/sources.list.d/raspi.list \
	&& apt-key adv --batch --keyserver keyserver.ubuntu.com  --recv-key 0x82B129927FA3303E

RUN apt-get update && apt-get install -y --no-install-recommends \
		less \
		libraspberrypi-bin \
		kmod \
		nano \
		net-tools \
		ifupdown \
		iputils-ping \
		i2c-tools \
		usbutils \
	&& rm -rf /var/lib/apt/lists/*

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo 'Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: ARM v7 \nOS: Debian Buster \nVariant: build variant \nDefault variable(s): UDEV=off \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only) \n- Keep the container idling with `balena-idle` command \n- Show base image details with `balena-info` command' > /.balena/messages/image-info