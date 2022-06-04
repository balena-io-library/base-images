FROM balenalib/aarch64-debian:bookworm-build
LABEL io.balena.device-type="coral-dev"

RUN apt-get update && apt-get install -y --no-install-recommends \
        less \
        kmod \
        nano \
        net-tools \
        ifupdown \
        iputils-ping \
        i2c-tools \
        usbutils \
        apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Add Google Coral sources lists
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Install the TPU packages
RUN install_packages  libedgetpu1-std \
        python3-edgetpu \
        libedgetpu-dev

RUN echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1a6e", GROUP="plugdev"' >> /etc/udev/rules.d/99-tpu.rules \
    && echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", GROUP="plugdev"' >> /etc/udev/rules.d/99-tpu.rule

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo 'Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: ARM v8 \nOS: Debian Bookworm \nVariant: build variant \nDefault variable(s): UDEV=off \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only) \n- Keep the container idling with `balena-idle` command \n- Show base image details with `balena-info` command' > /.balena/messages/image-info