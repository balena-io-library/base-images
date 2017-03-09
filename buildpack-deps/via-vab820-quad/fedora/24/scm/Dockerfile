FROM resin/via-vab820-quad-fedora-buildpack-deps:24-curl

RUN dnf install -y  \
		bzr \
		git \
		mercurial \
		openssh-clients \
		subversion \
	&& dnf clean all
