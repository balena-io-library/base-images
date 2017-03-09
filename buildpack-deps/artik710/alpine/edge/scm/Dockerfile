FROM resin/artik710-alpine-buildpack-deps:edge-curl

RUN apk add --update \
		bzr \
		git \
		mercurial \
		openssh-client \
		subversion \
	&& rm -rf /var/cache/apk/*
