FROM #{FROM}

LABEL io.resin.device-type="#{DEV_TYPE}"

COPY artik.repo /etc/yum.repos.d/
COPY RPM-GPG-KEY-artik /etc/pki/rpm-gpg/

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		git-core \
		i2c-tools \
		libartik-sdk-tests \
		libartik-sdk-zigbee-devel \
	&& dnf clean all
