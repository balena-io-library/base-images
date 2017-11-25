FROM resin/aarch64-alpine-buildpack-deps:latest

ENV GO_VERSION 1.8.5

RUN mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-alpine-aarch64.tar.gz" \
	&& echo "e046c40157ed47e37f23aea8a290c49c565c84e1c5828b34d1956f654e19f372  go1.8.5.linux-alpine-aarch64.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-alpine-aarch64.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-alpine-aarch64.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
