FROM #{FROM}

RUN dnf install -y \
		ca-certificates \
		curl \
		wget \
	&& dnf clean all
