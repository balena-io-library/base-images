FROM #{FROM}

RUN apk add --no-cache \
		ca-certificates \
		curl \
		wget
