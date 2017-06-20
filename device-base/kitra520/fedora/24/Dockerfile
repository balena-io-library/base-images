FROM resin/armv7hf-fedora:24

LABEL io.resin.device-type="kitra520"

COPY artik.repo /etc/yum.repos.d/
COPY RPM-GPG-KEY-artik /etc/pki/rpm-gpg/

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
		libartik-sdk-tests \
		libartik-sdk-zigbee-devel \
	&& dnf clean all
