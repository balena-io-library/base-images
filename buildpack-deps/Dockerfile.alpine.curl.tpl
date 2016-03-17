FROM #{FROM}

RUN apk add --update \
		ca-certificates \
		curl \
		wget \
	&& rm -rf /var/cache/apk/*
