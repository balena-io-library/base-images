FROM #{FROM}

RUN dnf install -y  \
		bzr \
		git \
		mercurial \
		openssh-clients \
		subversion \
	&& dnf clean all
