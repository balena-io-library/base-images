FROM resin/raspberrypi3-fedora-buildpack-deps:26-curl

RUN dnf install -y  \
		bzr \
		git \
		mercurial \
		openssh-clients \
		subversion \
	&& dnf clean all
