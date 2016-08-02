FROM resin/artik10-fedora-buildpack-deps:24-curl

RUN dnf install -y  \
		bzr \
		git \
		mercurial \
		openssh-clients \
		subversion \
	&& dnf clean all
