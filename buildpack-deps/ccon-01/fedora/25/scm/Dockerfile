FROM resin/ccon-01-fedora-buildpack-deps:25-curl

RUN dnf install -y  \
		bzr \
		git \
		mercurial \
		openssh-clients \
		subversion \
	&& dnf clean all
