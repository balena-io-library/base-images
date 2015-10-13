FROM resin/cubox-i-buildpack-deps:jessie

ENV GO_VERSION 1.5.1

RUN mkdir -p /usr/local/go \
	&& curl -SL "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go-v$GO_VERSION-linux-armv7hf.tar.gz" | tar xz -C /usr/local/go --strip-components=1

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/#/pages/using/dockerfile.md"]
