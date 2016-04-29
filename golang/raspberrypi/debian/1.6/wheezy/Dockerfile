FROM resin/raspberrypi-buildpack-deps:wheezy

ENV GO_VERSION 1.6.2

RUN mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-armv6hf.tar.gz" \
	&& echo "c725aebf35f19fc99abdc8b15a8d95c2b219d9e0ee690f27cf8a0dbded1ac9fb  go1.6.2.linux-armv6hf.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-armv6hf.tar.gz" -C /usr/local/go --strip-components=1

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/#/pages/using/dockerfile.md"]
