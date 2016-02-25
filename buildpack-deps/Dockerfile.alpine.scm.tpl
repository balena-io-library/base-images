FROM #{FROM}

RUN apk add --no-cache \
		bzr \
		git \
		mercurial \
		openssh-client \
		subversion
