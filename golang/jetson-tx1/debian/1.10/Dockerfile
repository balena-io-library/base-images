FROM resin/jetson-tx1-buildpack-deps:jessie

ENV GO_VERSION 1.10.2

RUN mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-aarch64.tar.gz" \
	&& echo "7026c5852dfe2ee4f50cbfbe62e6860a5e1a53995e9b34e705fe3e6be018abbd  go1.10.2.linux-aarch64.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-aarch64.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-aarch64.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
