FROM resin/imx6ul-var-dart-fedora-buildpack-deps:25-curl

RUN dnf install -y  \
		bzr \
		git \
		mercurial \
		openssh-clients \
		subversion \
	&& dnf clean all
