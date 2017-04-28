FROM #{FROM}

LABEL #{LABEL}

ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

#{QEMU}
#{QEMU_CPU}

RUN apt-get update && apt-get install -y --no-install-recommends \
		sudo \
		ca-certificates \
		findutils \
		gnupg \
		dirmngr \
	&& rm -rf /var/lib/apt/lists/*

COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/
COPY 01_buildconfig /etc/apt/apt.conf.d/
