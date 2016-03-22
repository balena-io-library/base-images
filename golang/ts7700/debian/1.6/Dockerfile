FROM resin/ts7700-buildpack-deps:jessie

ENV GO_VERSION 1.6

RUN mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-armel.tar.gz" \
	&& echo "1e51dad91c15cd0b2686faa1e0460d818b436cdbed5f46c0b6816ac5842ba719  go1.6.linux-armel.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-armel.tar.gz" -C /usr/local/go --strip-components=1

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/#/pages/using/dockerfile.md"]
