FROM balenalib/aarch64-ubuntu:bionic-run
LABEL io.balena.device-type="jetson-nano-emmc"
RUN echo "deb https://repo.download.nvidia.com/jetson/common r32.7 main" >>  /etc/apt/sources.list.d/nvidia.list \
	&& echo "deb https://repo.download.nvidia.com/jetson/t210 r32.7 main" >>  /etc/apt/sources.list.d/nvidia.list \
	&& apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc \
	&& mkdir -p /opt/nvidia/l4t-packages/ && touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall

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

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo 'Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: ARM v8 \nOS: Ubuntu bionic \nVariant: run variant \nDefault variable(s): UDEV=off \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only) \n- Keep the container idling with `balena-idle` command \n- Show base image details with `balena-info` command' > /.balena/messages/image-info