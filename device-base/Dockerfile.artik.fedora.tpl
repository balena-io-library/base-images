FROM #{FROM}

LABEL io.resin.device-type="#{DEV_TYPE}"

COPY artik.repo /etc/yum.repos.d/
COPY RPM-GPG-KEY-artik-#{SUITE}-armhfp /etc/pki/rpm-gpg/

RUN dnf install -y \
		less \
		nano \
		net-tools \
		usbutils \
		gnupg \
		i2c-tools \
		libartik-sdk-tests \
	&& dnf clean all
