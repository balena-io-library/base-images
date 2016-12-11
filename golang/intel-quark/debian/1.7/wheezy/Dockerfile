FROM resin/intel-quark-buildpack-deps:wheezy

ENV GO_VERSION 1.7.4

RUN mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-i386.tar.gz" \
	&& echo "015c03c37e9bc6b0c76b3f3573c3224c6e09c977d9e02b7f7d87b5b14f4feb7d  go1.7.4.linux-i386.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-i386.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-i386.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
