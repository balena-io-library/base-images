FROM resin/beaglebone-black-fedora-buildpack-deps:23-curl

RUN dnf install -y  \
		bzr \
		git \
		mercurial \
		openssh-clients \
		subversion \
	&& dnf clean all
